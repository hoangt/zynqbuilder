-- File:     spi_interface.vhd
-- 
-- Created:  12-12-02 JRH
--  This file contains the interconnect structure of the SPI interface portion of
--  the SPI Master design.  It was originally created in schematic form, but was
--  converted to VHDL from the VHF file generated by the ECS tool.
--

LIBRARY ieee;
LIBRARY UNISIM;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE UNISIM.Vcomponents.ALL;

ENTITY spi_interface IS
   PORT (
      reset          :  IN    STD_LOGIC;                     -- Reset
      clk            :  IN    STD_LOGIC;                     -- Input Clock
      clkdiv         :  IN    STD_LOGIC_VECTOR(1 DOWNTO 0);  -- Clock Divider Sets 4,8,16,32
      
      -- CONTROLS Latched PER transaction
      tx_sel         :  IN    STD_LOGIC_VECTOR(1 downto 0);    -- Mode Bit (Future) & Transmit/Receive
                                                               -- Bit 1: (Future don't care for now)
                                                               -- When 1  Enables Mode Selection
                                                                  -- when bit 1 = 1 and bit 0 = 0 Full Duplex
                                                                  -- when bit 1 = 1 and bit 0 = 1 Bi-SPI (TX Line) (FUTURE)
                                                               -- When 0 : Half Duplex
                                                                  -- Bit 0: Tr (1)/Rx (0)
      numb_bytes     :  IN    STD_LOGIC_VECTOR(1 downto 0); -- Number of Bytes for this transaction (Zero-based numbering)
      slave_sel      :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Slave Enable Mask Signals (Active High). (7 downto 1 Future for now X)
      start          :  IN    STD_LOGIC;                    -- Start Transaction (Disabled when Done = '1')
      done_ack       :  IN    STD_LOGIC;                    -- Done Ack, use to clear Done Bit
      done           :  OUT   STD_LOGIC;                    -- Transaction Is Complete, must be cleared before next
                                                                                        -- Transaction
      --tx_bit_order   :  IN    STD_LOGIC;                    -- 1: MSB first, 0: LSB first
      ss_polarity    :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Slave Select Polarity for ASSERTED State
      cpol_cpha      :  IN    STD_LOGIC_VECTOR(1 downto 0); -- Clock Polarity, Clock Phase
                                                            -- Mode   CPOL  CPHA
                                                            -- 0      0     0
                                                            -- 1      0     1
                                                            -- 2      1     0
                                                            -- 3      1     1
                                                            -- At CPOL=0 the base value of the clock is zero
                                                               -- For CPHA=0, data are captured on the clock's rising edge 
                                                               -- For CPHA=1, data are captured on the clock's falling edge
                                                            -- At CPOL=1 the base value of the clock is one (inversion of CPOL=0)
                                                               -- For CPHA=0, data are captured on clock's falling edge
                                                               -- For CPHA=1, data are captured on clock's rising edge
                           
      -- TX (INTERNAL) Latched PER transaction
      xmit_data1     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
      xmit_data2     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
      xmit_data3     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
      xmit_data4     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
      
      -- RX (INTERNAL) Held Until done_ack
      recv_data1     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
      recv_data2     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
      recv_data3     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
      recv_data4     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
      
      -- INTERFACE
      ss_n           :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Slave Chip Select Signals (7 downto 1 Future, for now DNI)
      miso           :  IN    STD_LOGIC;                    -- Master In Slave Out
      mosi           :  OUT   STD_LOGIC;                    -- Master Out Slave In
      sck            :  OUT   STD_LOGIC                     -- S Clock Out
   );

end spi_interface;

ARCHITECTURE SCHEMATIC OF spi_interface IS
   SIGNAL i_sck      :	STD_LOGIC;
   SIGNAL sck_ph1	   :	STD_LOGIC;
   SIGNAL sck_fe	   :	STD_LOGIC;
   SIGNAL sck_int_fe	:	STD_LOGIC;
   SIGNAL sck_int_re	:	STD_LOGIC;
   SIGNAL sck_re  	:	STD_LOGIC;
   SIGNAL xmit_load	:	STD_LOGIC;
   SIGNAL xmit_data	:	STD_LOGIC_VECTOR(7 downto 0);

   signal i_tx_sel      : STD_LOGIC_VECTOR(1 downto 0);
   signal i_numb_bytes  : STD_LOGIC_VECTOR(1 downto 0);
   signal i_slave_sel   : STD_LOGIC_VECTOR(7 downto 0);
   signal i_cpol_cpha   : STD_LOGIC_VECTOR(1 downto 0);
   signal i_xmit_data1  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_xmit_data2  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_xmit_data3  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_xmit_data4  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_recv_data1  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_recv_data2  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_recv_data3  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_recv_data4  : STD_LOGIC_VECTOR(7 downto 0);
   signal i_done_ack_ary: STD_LOGIC_VECTOR(1 downto 0);
   signal i_done        : STD_LOGIC;
   
   type SPI_STATE_TYPE is (IDLE, ASSERT_SSN1, ASSERT_SSN2, UNMASK_SCK, XFER_DATA1, 
                           XFER_DATA2, XFER_DATA3, XFER_DATA4, ASSERT_DONE, 
                           HOLD_SSN1, HOLD_SSN2,NEGATE_SSN);
   signal spi_state        : SPI_STATE_TYPE;
   
   --ATTRIBUTE fpga_dont_touch : STRING ;
   --ATTRIBUTE fpga_dont_touch OF XLXI_9 : LABEL IS "true";


   COMPONENT sck_logic
      PORT ( 
         -- clock and reset
         reset          : in    std_logic;  -- active high reset    
         clk            : in    std_logic;  -- clock
         
         -- internal interface signals
         clkdiv         : in    std_logic_vector(1 downto 0);   -- sets the clock divisor for sck clock
         cpol           : in    std_logic;  -- sets clock polarity for output sck clock
         cpha           : in    std_logic;  -- sets clock phase for output sck clock
         
         -- internal spi interface signals
         clkph0_mask    : in    std_logic;  -- clock mask for sck when cpha=0
         clkph1_mask    : in    std_logic;  -- clock mask for sck when cpha=1
         sck_ph1        : out   std_logic;  -- internal sck created from dividing system clock
         sck_int_re     : out   std_logic;  -- rising edge of internal sck
         sck_int_fe     : out   std_logic;  -- falling edge of internal sck
         sck_re         : out   std_logic;  -- rising edge of external sck
         sck_fe         : out   std_logic;  -- falling edge of external sck
         
         -- external spi interface signals
         sck            : out  std_logic    -- sck as determined by cpha, cpol, and clkdiv
      );
   END COMPONENT;
   signal i_clk0_mask : STD_LOGIC;
   signal i_clk1_mask : STD_LOGIC;
   
   COMPONENT spi_rcv_shift_reg
      PORT ( 
         reset       :   IN   STD_LOGIC; 
         sclk        :   IN   STD_LOGIC; 
         miso        :   IN   STD_LOGIC; 
         shift_en    :   IN   STD_LOGIC; 
         data_out    :   OUT  STD_LOGIC_VECTOR(7 DOWNTO 0); 
         rcv_load    :   OUT  STD_LOGIC;
         sck_re      :   IN   STD_LOGIC; 
         sck_fe      :   IN   STD_LOGIC; 
         cpol_cpha   :   IN   STD_LOGIC_VECTOR(1 downto 0)
      );
   END COMPONENT;
   signal rcv_data   : STD_LOGIC_VECTOR(7 downto 0);
   signal rcv_load   : STD_LOGIC;
   signal i_shift_en : STD_LOGIC;
   
   COMPONENT spi_xmit_shift_reg
      PORT ( 
         reset       :   IN   STD_LOGIC; 
         sys_clk     :   IN   STD_LOGIC; 
         sclk        :   IN   STD_LOGIC; 
         -- two modes to load data parallel and serial
         data_ld     :   IN   STD_LOGIC; 
         data_in     :   IN   STD_LOGIC_VECTOR (7 DOWNTO 0); 
         shift_en    :   IN   STD_LOGIC; 
         shift_in    :   IN   STD_LOGIC; 
         mosi        :   OUT  STD_LOGIC
      );
   END COMPONENT;
   signal tx_data_shift_in : STD_LOGIC;
   signal tx_shift_en      : STD_LOGIC;

BEGIN

   --XLXI_9 : NAND2B1
   --   PORT MAP (I0=>xmit_shift, I1=>xmit_shift, O=>vcc);
   
   SCK_GEN : sck_logic
      PORT MAP (
         -- clock and reset
         clk            => clk,            -- : in    std_logic   -- clock
         reset          => reset,          -- : in    std_logic;  -- active high reset    
   
         -- internal interface signals
         clkdiv         => clkdiv,         -- : in    std_logic_vector(1 downto 0);   -- sets the clock divisor for sck clock
         cpol           => i_cpol_cpha(1), -- : in    std_logic;  -- sets clock polarity for output sck clock
         cpha           => i_cpol_cpha(0), -- : in    std_logic;  -- sets clock phase for output sck clock
         
         -- internal spi interface signals
         clkph0_mask    => i_clk0_mask,    -- : in    std_logic;  -- clock mask for sck when cpha=0
         clkph1_mask    => i_clk1_mask,    -- : in    std_logic;  -- clock mask for sck when cpha=1
         sck_ph1        => sck_ph1,        -- : out   std_logic;  -- internal sck created from dividing system clock
         sck_int_re     => sck_int_re,     -- : out   std_logic;  -- rising edge of internal sck
         sck_int_fe     => sck_int_fe,     -- : out   std_logic;  -- falling edge of internal sck
         sck_re         => sck_re,         -- : out   std_logic;  -- rising edge of external sck
         sck_fe         => sck_fe,         -- : out   std_logic;  -- falling edge of external sck
         
         -- external spi interface signals
         sck            => i_sck           -- : out  std_logic;      -- sck as determined by cpha, cpol, and clkdiv
      );
sck <= i_sck;
      
rcv_shift_reg : spi_rcv_shift_reg
   PORT MAP (
      sclk      =>i_sck, 
      reset     =>reset,
      miso      =>miso, 
      shift_en  =>i_shift_en,
      data_out  => rcv_data,
      rcv_load  => rcv_load,
      sck_re    =>sck_re, 
      sck_fe    =>sck_fe, 
      cpol_cpha =>i_cpol_cpha
   );

xmit_shift_reg : spi_xmit_shift_reg
   PORT MAP (
      reset    =>reset,
      sys_clk  =>clk,
      sclk     =>sck_ph1,
      data_ld  =>xmit_load,
      data_in  =>xmit_data,
      shift_en =>tx_shift_en,
      shift_in =>tx_data_shift_in,
      mosi     =>mosi
   );

recv_data1   <= i_recv_data1;
recv_data2   <= i_recv_data2;
recv_data3   <= i_recv_data3;
recv_data4   <= i_recv_data4;
done         <= i_done;
spi_control_sm: process(reset, clk, spi_state, start,sck_re, sck_fe, sck_int_re, sck_int_fe, ss_polarity)
begin

   if( reset = '1') then
      -- set defaults      
      ss_n              <= not(ss_polarity);
      i_xmit_data1      <= (others=>'0');
      i_xmit_data2      <= (others=>'0');
      i_xmit_data3      <= (others=>'0');
      i_xmit_data4      <= (others=>'0');
      i_recv_data1      <= (others=>'0');
      i_recv_data2      <= (others=>'0');
      i_recv_data3      <= (others=>'0');
      i_recv_data4      <= (others=>'0');
      i_cpol_cpha       <= (others=>'0');
      spi_state         <= IDLE;
      i_done_ack_ary    <= (others=>'0');
      i_done            <= '0';
      i_shift_en        <= '0';
      tx_data_shift_in  <= '0';
      tx_shift_en       <= '0';
      
      i_clk0_mask       <= '0';
      i_clk1_mask       <= '0';
      xmit_load         <= '0';      
   elsif(rising_edge(clk)) then
      -- give done_ack hysteresis to force done ack PER transaction
      -- prevents runaway looping!
      -- Only transition the array when DONE is being ACKED, otherwise
      -- IMMEDIATLY set to 0 to prevent having to wait for the array to clear
      if done_ack = '0' then
         i_done_ack_ary <= (others=>'0');
      else
         i_done_ack_ary <= i_done_ack_ary(0) & done_ack;
      end if;
      
      case spi_state is
        --********************* IDLE State *****************
        when IDLE =>
            ss_n        <= not(ss_polarity);
            xmit_load   <= '0'; 
            i_shift_en  <= '0';
            
            -- look for the transition from 0 to 1 acking the DONE
            -- however if done_ack is stale (bit 1 is a 1) do not continue
            if i_done_ack_ary(1) = '0' and i_done_ack_ary(0) = '1'  then
               i_done <= '0';
            end if;
            
            if start = '1' and i_done = '0' then
                spi_state <= ASSERT_SSN1;
            end if;

        --********************* ASSERT_SSN1 State *****************
        when ASSERT_SSN1 =>
            -- Register the world!
            i_tx_sel       <= tx_sel;
            i_numb_bytes   <= numb_bytes;
            i_slave_sel    <= slave_sel;
            i_cpol_cpha    <= cpol_cpha;
            i_xmit_data1   <= xmit_data1;
            i_xmit_data2   <= xmit_data2;
            i_xmit_data3   <= xmit_data3;
            i_xmit_data4   <= xmit_data4;
            
            -- this state asserts SS_N and waits for first edge of SCK_INT
            -- SS_N must be asserted ~1 SCK before SCK is output from chip
            if sck_int_re = '1' then
               -- enable ss_n
               -- Future add all bits for i_slave_sel
               --check if greater than 1 to ensure only one device being driven
               ss_n           <= not(i_slave_sel xor ss_polarity);
               spi_state <= ASSERT_SSN2;
            end if;
            
         --********************* ASSERT_SSN2 State *****************
        when ASSERT_SSN2 =>
            -- this state asserts SS_N and waits for next edge of SCK_INT
            -- SS_N must be asserted ~1 SCK before SCK is output from chip
            if sck_int_fe = '1' then
                spi_state <= UNMASK_SCK;
            end if;
            
       --********************* UNMASK_SCK State *****************
        when UNMASK_SCK =>
            i_shift_en <= '1';  -- enable bit counter
            i_clk1_mask <= '1';   -- unmask sck_ph1
            xmit_data <= i_xmit_data1;
            
            if sck_int_re = '1' then
               -- first rising edge of CPHA=1 clock with SS_N asserted
               -- transition to XFER_BIT state and unmask CPHA=0 clk
               spi_state <= XFER_DATA1;
               xmit_load <= '0';   -- 1st byte loaded
            else
               xmit_load <= '1';   -- load SPI shift register
            end if;

        --********************* XFER_DATA1 State *****************
        when XFER_DATA1 =>
            i_clk0_mask       <= '1';   -- unmask CPHA=0 clock
            i_clk1_mask       <= '1';   -- unmask CPHA=1 clock
            tx_data_shift_in  <= i_xmit_data2(7);  -- Preload next byte
            tx_shift_en       <= '1';

            -- start loading the next byte
            if sck_int_re = '1' then
               i_xmit_data2      <= i_xmit_data2(6 downto 0) & '0';
            end if;            
            i_recv_data1   <= rcv_data;
            -- all 8 bits have transferred
            if numb_bytes > "00" and rcv_load = '1' then
                spi_state <= XFER_DATA2;
            elsif rcv_load = '1' then
               spi_state <= ASSERT_DONE;
               i_shift_en  <= '0';  -- disable / reset bit counter
            else
               i_shift_en  <= '1';  -- enable bit counter
            end if;

        --********************* XFER_DATA2 State *****************
        when XFER_DATA2 =>
            i_clk0_mask <= '1';   -- unmask CPHA=0 clock
            i_clk1_mask <= '1';   -- unmask CPHA=1 clock
            tx_data_shift_in  <= i_xmit_data3(7);  -- Preload next byte
            tx_shift_en       <= '1';

            -- start loading the next byte
            if sck_int_re = '1' then
               i_xmit_data3      <= i_xmit_data3(6 downto 0) & '0';
            end if; 
            i_recv_data2   <= rcv_data;
            -- all 8 bits have transferred
            if numb_bytes > "01" and rcv_load = '1' then
                spi_state <= XFER_DATA3;
            elsif rcv_load = '1' then
               spi_state <= ASSERT_DONE;
               i_shift_en  <= '0';  -- disable / reset bit counter
            else
               i_shift_en  <= '1';  -- enable bit counter
            end if;
            
        --********************* XFER_DATA3 State *****************
        when XFER_DATA3 =>
            i_clk0_mask <= '1';   -- unmask CPHA=0 clock
            i_clk1_mask <= '1';   -- unmask CPHA=1 clock
            tx_data_shift_in  <= i_xmit_data4(7);  -- Preload next byte
            tx_shift_en       <= '1';

            -- start loading the next byte
            if sck_int_re = '1' then
               i_xmit_data4      <= i_xmit_data4(6 downto 0) & '0';
            end if; 
            i_recv_data3   <= rcv_data;
            -- all 8 bits have transferred
            if numb_bytes > "10" and rcv_load = '1' then
               spi_state <= XFER_DATA4;
            elsif rcv_load = '1' then
               spi_state <= ASSERT_DONE;
               i_shift_en  <= '0';  -- disable / reset bit counter
            else
               i_shift_en  <= '1';  -- enable bit counter
            end if;
            
        --********************* XFER_DATA4 State *****************
        when XFER_DATA4 =>
            i_clk0_mask <= '1';   -- unmask CPHA=0 clock
            i_clk1_mask <= '1';   -- unmask CPHA=1 clock
            tx_data_shift_in  <= '0';  -- Preloaded shift in fodder
            tx_shift_en       <= '1';

            i_recv_data4   <= rcv_data;
            -- all 8 bits have transferred
            if rcv_load = '1' then
               spi_state <= ASSERT_DONE;
               i_shift_en  <= '0';  -- disable / reset bit counter
            else
               i_shift_en  <= '1';  -- enable bit counter
            end if;
            
        --********************* ASSERT_DONE State *****************
        when ASSERT_DONE =>
            -- this state begins to assert done so that new data
            -- can be written into the transmit register or data
            -- can be read from the receive register
            i_clk0_mask    <= '0';
            i_clk1_mask    <= '0';
            tx_shift_en    <= '0';

            if sck_int_fe = '1' then
                spi_state <= HOLD_SSN1;
            end if;
            
        --********************* HOLD_SSN1 State *****************
        when HOLD_SSN1 =>
            -- This state waits for another SCK edge
            -- to provide SS_N hold time
            if  sck_int_fe = '1' then
               spi_state <= HOLD_SSN2;
            end if;
            
        --********************* HOLD_SSN2 State *****************
        when HOLD_SSN2 =>
            -- This state waits for another SCK edge
            -- to provide SS_N hold time
            if  sck_int_fe = '1' then
               i_done <= '1';
               spi_state <= NEGATE_SSN;
            end if;

        --********************* NEGATE_SSN State *****************
        when NEGATE_SSN =>
            -- SS_N should negate for an entire SCK
            -- This state waits for an SCK edge
            ss_n        <= not(ss_polarity);
            spi_state   <= IDLE;
    
        --********************* Default State *****************
        when others =>
            spi_state <= IDLE;
    end case;
   end if;
end process;

END SCHEMATIC;



