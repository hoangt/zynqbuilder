// ==============================================================
// File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2013.3
// Copyright (C) 2013 Xilinx Inc. All rights reserved.
// 
// ==============================================================

`timescale 1ns/1ps
module sobel_filter_CONTROL_BUS_if
#(parameter
    C_ADDR_WIDTH = 8,
    C_DATA_WIDTH = 32
)(
    // axi4 lite slave signals
    input  wire                      ACLK,
    input  wire                      ARESETN,
    input  wire [C_ADDR_WIDTH-1:0]   AWADDR,
    input  wire                      AWVALID,
    output wire                      AWREADY,
    input  wire [C_DATA_WIDTH-1:0]   WDATA,
    input  wire [C_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                      WVALID,
    output wire                      WREADY,
    output wire [1:0]                BRESP,
    output wire                      BVALID,
    input  wire                      BREADY,
    input  wire [C_ADDR_WIDTH-1:0]   ARADDR,
    input  wire                      ARVALID,
    output wire                      ARREADY,
    output wire [C_DATA_WIDTH-1:0]   RDATA,
    output wire [1:0]                RRESP,
    output wire                      RVALID,
    input  wire                      RREADY,
    output wire                      interrupt,
    // user signals
    output wire [31:0]               I_rows,
    output wire [31:0]               I_cols,
    output wire [31:0]               I_C_XR0C0,
    output wire [31:0]               I_C_XR0C1,
    output wire [31:0]               I_C_XR0C2,
    output wire [31:0]               I_C_XR1C0,
    output wire [31:0]               I_C_XR1C1,
    output wire [31:0]               I_C_XR1C2,
    output wire [31:0]               I_C_XR2C0,
    output wire [31:0]               I_C_XR2C1,
    output wire [31:0]               I_C_XR2C2,
    output wire [31:0]               I_C_YR0C0,
    output wire [31:0]               I_C_YR0C1,
    output wire [31:0]               I_C_YR0C2,
    output wire [31:0]               I_C_YR1C0,
    output wire [31:0]               I_C_YR1C1,
    output wire [31:0]               I_C_YR1C2,
    output wire [31:0]               I_C_YR2C0,
    output wire [31:0]               I_C_YR2C1,
    output wire [31:0]               I_C_YR2C2,
    output wire [31:0]               I_c_high_thesh,
    output wire [31:0]               I_c_low_thresh,
    output wire [31:0]               I_c_invert,
    output wire                      I_ap_start,
    input  wire                      O_ap_ready,
    input  wire                      O_ap_done,
    input  wire                      O_ap_idle
);
//------------------------Address Info-------------------
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x10 : reserved
// 0x14 : Data signal of rows
//        bit 31~0 - rows[31:0] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of cols
//        bit 31~0 - cols[31:0] (Read/Write)
// 0x20 : reserved
// 0x24 : Data signal of C_XR0C0
//        bit 31~0 - C_XR0C0[31:0] (Read/Write)
// 0x28 : reserved
// 0x2c : Data signal of C_XR0C1
//        bit 31~0 - C_XR0C1[31:0] (Read/Write)
// 0x30 : reserved
// 0x34 : Data signal of C_XR0C2
//        bit 31~0 - C_XR0C2[31:0] (Read/Write)
// 0x38 : reserved
// 0x3c : Data signal of C_XR1C0
//        bit 31~0 - C_XR1C0[31:0] (Read/Write)
// 0x40 : reserved
// 0x44 : Data signal of C_XR1C1
//        bit 31~0 - C_XR1C1[31:0] (Read/Write)
// 0x48 : reserved
// 0x4c : Data signal of C_XR1C2
//        bit 31~0 - C_XR1C2[31:0] (Read/Write)
// 0x50 : reserved
// 0x54 : Data signal of C_XR2C0
//        bit 31~0 - C_XR2C0[31:0] (Read/Write)
// 0x58 : reserved
// 0x5c : Data signal of C_XR2C1
//        bit 31~0 - C_XR2C1[31:0] (Read/Write)
// 0x60 : reserved
// 0x64 : Data signal of C_XR2C2
//        bit 31~0 - C_XR2C2[31:0] (Read/Write)
// 0x68 : reserved
// 0x6c : Data signal of C_YR0C0
//        bit 31~0 - C_YR0C0[31:0] (Read/Write)
// 0x70 : reserved
// 0x74 : Data signal of C_YR0C1
//        bit 31~0 - C_YR0C1[31:0] (Read/Write)
// 0x78 : reserved
// 0x7c : Data signal of C_YR0C2
//        bit 31~0 - C_YR0C2[31:0] (Read/Write)
// 0x80 : reserved
// 0x84 : Data signal of C_YR1C0
//        bit 31~0 - C_YR1C0[31:0] (Read/Write)
// 0x88 : reserved
// 0x8c : Data signal of C_YR1C1
//        bit 31~0 - C_YR1C1[31:0] (Read/Write)
// 0x90 : reserved
// 0x94 : Data signal of C_YR1C2
//        bit 31~0 - C_YR1C2[31:0] (Read/Write)
// 0x98 : reserved
// 0x9c : Data signal of C_YR2C0
//        bit 31~0 - C_YR2C0[31:0] (Read/Write)
// 0xa0 : reserved
// 0xa4 : Data signal of C_YR2C1
//        bit 31~0 - C_YR2C1[31:0] (Read/Write)
// 0xa8 : reserved
// 0xac : Data signal of C_YR2C2
//        bit 31~0 - C_YR2C2[31:0] (Read/Write)
// 0xb0 : reserved
// 0xb4 : Data signal of c_high_thesh
//        bit 31~0 - c_high_thesh[31:0] (Read/Write)
// 0xb8 : reserved
// 0xbc : Data signal of c_low_thresh
//        bit 31~0 - c_low_thresh[31:0] (Read/Write)
// 0xc0 : reserved
// 0xc4 : Data signal of c_invert
//        bit 31~0 - c_invert[31:0] (Read/Write)
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
// address bits
localparam
    ADDR_BITS = 8;

// address
localparam
    ADDR_AP_CTRL             = 8'h00,
    ADDR_GIE                 = 8'h04,
    ADDR_IER                 = 8'h08,
    ADDR_ISR                 = 8'h0c,
    ADDR_ROWS_CTRL           = 8'h10,
    ADDR_ROWS_DATA_0         = 8'h14,
    ADDR_COLS_CTRL           = 8'h18,
    ADDR_COLS_DATA_0         = 8'h1c,
    ADDR_C_XR0C0_CTRL        = 8'h20,
    ADDR_C_XR0C0_DATA_0      = 8'h24,
    ADDR_C_XR0C1_CTRL        = 8'h28,
    ADDR_C_XR0C1_DATA_0      = 8'h2c,
    ADDR_C_XR0C2_CTRL        = 8'h30,
    ADDR_C_XR0C2_DATA_0      = 8'h34,
    ADDR_C_XR1C0_CTRL        = 8'h38,
    ADDR_C_XR1C0_DATA_0      = 8'h3c,
    ADDR_C_XR1C1_CTRL        = 8'h40,
    ADDR_C_XR1C1_DATA_0      = 8'h44,
    ADDR_C_XR1C2_CTRL        = 8'h48,
    ADDR_C_XR1C2_DATA_0      = 8'h4c,
    ADDR_C_XR2C0_CTRL        = 8'h50,
    ADDR_C_XR2C0_DATA_0      = 8'h54,
    ADDR_C_XR2C1_CTRL        = 8'h58,
    ADDR_C_XR2C1_DATA_0      = 8'h5c,
    ADDR_C_XR2C2_CTRL        = 8'h60,
    ADDR_C_XR2C2_DATA_0      = 8'h64,
    ADDR_C_YR0C0_CTRL        = 8'h68,
    ADDR_C_YR0C0_DATA_0      = 8'h6c,
    ADDR_C_YR0C1_CTRL        = 8'h70,
    ADDR_C_YR0C1_DATA_0      = 8'h74,
    ADDR_C_YR0C2_CTRL        = 8'h78,
    ADDR_C_YR0C2_DATA_0      = 8'h7c,
    ADDR_C_YR1C0_CTRL        = 8'h80,
    ADDR_C_YR1C0_DATA_0      = 8'h84,
    ADDR_C_YR1C1_CTRL        = 8'h88,
    ADDR_C_YR1C1_DATA_0      = 8'h8c,
    ADDR_C_YR1C2_CTRL        = 8'h90,
    ADDR_C_YR1C2_DATA_0      = 8'h94,
    ADDR_C_YR2C0_CTRL        = 8'h98,
    ADDR_C_YR2C0_DATA_0      = 8'h9c,
    ADDR_C_YR2C1_CTRL        = 8'ha0,
    ADDR_C_YR2C1_DATA_0      = 8'ha4,
    ADDR_C_YR2C2_CTRL        = 8'ha8,
    ADDR_C_YR2C2_DATA_0      = 8'hac,
    ADDR_C_HIGH_THESH_CTRL   = 8'hb0,
    ADDR_C_HIGH_THESH_DATA_0 = 8'hb4,
    ADDR_C_LOW_THRESH_CTRL   = 8'hb8,
    ADDR_C_LOW_THRESH_DATA_0 = 8'hbc,
    ADDR_C_INVERT_CTRL       = 8'hc0,
    ADDR_C_INVERT_DATA_0     = 8'hc4;

// axi write fsm
localparam
    WRIDLE = 2'd0,
    WRDATA = 2'd1,
    WRRESP = 2'd2;

// axi read fsm
localparam
    RDIDLE = 2'd0,
    RDDATA = 2'd1;

//------------------------Local signal-------------------
// axi write
reg  [1:0]           wstate;
reg  [1:0]           wnext;
reg  [ADDR_BITS-1:0] waddr;
wire [31:0]          wmask;
wire                 aw_hs;
wire                 w_hs;
// axi read
reg  [1:0]           rstate;
reg  [1:0]           rnext;
reg  [31:0]          rdata;
wire                 ar_hs;
wire [ADDR_BITS-1:0] raddr;
// internal registers
wire                 ap_idle;
reg                  ap_done;
wire                 ap_ready;
reg                  ap_start;
reg                  auto_restart;
reg                  gie;
reg  [1:0]           ier;
reg  [1:0]           isr;
reg  [31:0]          _rows;
reg  [31:0]          _cols;
reg  [31:0]          _C_XR0C0;
reg  [31:0]          _C_XR0C1;
reg  [31:0]          _C_XR0C2;
reg  [31:0]          _C_XR1C0;
reg  [31:0]          _C_XR1C1;
reg  [31:0]          _C_XR1C2;
reg  [31:0]          _C_XR2C0;
reg  [31:0]          _C_XR2C1;
reg  [31:0]          _C_XR2C2;
reg  [31:0]          _C_YR0C0;
reg  [31:0]          _C_YR0C1;
reg  [31:0]          _C_YR0C2;
reg  [31:0]          _C_YR1C0;
reg  [31:0]          _C_YR1C1;
reg  [31:0]          _C_YR1C2;
reg  [31:0]          _C_YR2C0;
reg  [31:0]          _C_YR2C1;
reg  [31:0]          _C_YR2C2;
reg  [31:0]          _c_high_thesh;
reg  [31:0]          _c_low_thresh;
reg  [31:0]          _c_invert;

//------------------------Body---------------------------
//++++++++++++++++++++++++axi write++++++++++++++++++++++
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (~ARESETN)
        wstate <= WRIDLE;
    else
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (aw_hs)
        waddr <= AWADDR[ADDR_BITS-1:0];
end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++axi read+++++++++++++++++++++++
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (~ARESETN)
        rstate <= RDIDLE;
    else
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ar_hs) begin
        rdata <= 1'b0;
        case (raddr)
            ADDR_AP_CTRL: begin
                rdata[0] <= ap_start;
                rdata[1] <= ap_done;
                rdata[2] <= ap_idle;
                rdata[3] <= ap_ready;
                rdata[7] <= auto_restart;
            end
            ADDR_GIE: begin
                rdata <= gie;
            end
            ADDR_IER: begin
                rdata <= ier;
            end
            ADDR_ISR: begin
                rdata <= isr;
            end
            ADDR_ROWS_DATA_0: begin
                rdata <= _rows[31:0];
            end
            ADDR_COLS_DATA_0: begin
                rdata <= _cols[31:0];
            end
            ADDR_C_XR0C0_DATA_0: begin
                rdata <= _C_XR0C0[31:0];
            end
            ADDR_C_XR0C1_DATA_0: begin
                rdata <= _C_XR0C1[31:0];
            end
            ADDR_C_XR0C2_DATA_0: begin
                rdata <= _C_XR0C2[31:0];
            end
            ADDR_C_XR1C0_DATA_0: begin
                rdata <= _C_XR1C0[31:0];
            end
            ADDR_C_XR1C1_DATA_0: begin
                rdata <= _C_XR1C1[31:0];
            end
            ADDR_C_XR1C2_DATA_0: begin
                rdata <= _C_XR1C2[31:0];
            end
            ADDR_C_XR2C0_DATA_0: begin
                rdata <= _C_XR2C0[31:0];
            end
            ADDR_C_XR2C1_DATA_0: begin
                rdata <= _C_XR2C1[31:0];
            end
            ADDR_C_XR2C2_DATA_0: begin
                rdata <= _C_XR2C2[31:0];
            end
            ADDR_C_YR0C0_DATA_0: begin
                rdata <= _C_YR0C0[31:0];
            end
            ADDR_C_YR0C1_DATA_0: begin
                rdata <= _C_YR0C1[31:0];
            end
            ADDR_C_YR0C2_DATA_0: begin
                rdata <= _C_YR0C2[31:0];
            end
            ADDR_C_YR1C0_DATA_0: begin
                rdata <= _C_YR1C0[31:0];
            end
            ADDR_C_YR1C1_DATA_0: begin
                rdata <= _C_YR1C1[31:0];
            end
            ADDR_C_YR1C2_DATA_0: begin
                rdata <= _C_YR1C2[31:0];
            end
            ADDR_C_YR2C0_DATA_0: begin
                rdata <= _C_YR2C0[31:0];
            end
            ADDR_C_YR2C1_DATA_0: begin
                rdata <= _C_YR2C1[31:0];
            end
            ADDR_C_YR2C2_DATA_0: begin
                rdata <= _C_YR2C2[31:0];
            end
            ADDR_C_HIGH_THESH_DATA_0: begin
                rdata <= _c_high_thesh[31:0];
            end
            ADDR_C_LOW_THRESH_DATA_0: begin
                rdata <= _c_low_thresh[31:0];
            end
            ADDR_C_INVERT_DATA_0: begin
                rdata <= _c_invert[31:0];
            end
        endcase
    end
end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++internal registers+++++++++++++
assign interrupt      = gie & (|isr);
assign I_ap_start     = ap_start;
assign ap_idle        = O_ap_idle;
assign ap_ready       = O_ap_ready;
assign I_rows         = _rows;
assign I_cols         = _cols;
assign I_C_XR0C0      = _C_XR0C0;
assign I_C_XR0C1      = _C_XR0C1;
assign I_C_XR0C2      = _C_XR0C2;
assign I_C_XR1C0      = _C_XR1C0;
assign I_C_XR1C1      = _C_XR1C1;
assign I_C_XR1C2      = _C_XR1C2;
assign I_C_XR2C0      = _C_XR2C0;
assign I_C_XR2C1      = _C_XR2C1;
assign I_C_XR2C2      = _C_XR2C2;
assign I_C_YR0C0      = _C_YR0C0;
assign I_C_YR0C1      = _C_YR0C1;
assign I_C_YR0C2      = _C_YR0C2;
assign I_C_YR1C0      = _C_YR1C0;
assign I_C_YR1C1      = _C_YR1C1;
assign I_C_YR1C2      = _C_YR1C2;
assign I_C_YR2C0      = _C_YR2C0;
assign I_C_YR2C1      = _C_YR2C1;
assign I_C_YR2C2      = _C_YR2C2;
assign I_c_high_thesh = _c_high_thesh;
assign I_c_low_thresh = _c_low_thresh;
assign I_c_invert     = _c_invert;

// ap_start
always @(posedge ACLK) begin
    if (~ARESETN)
        ap_start <= 1'b0;
    else if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0] && WDATA[0])
        ap_start <= 1'b1;
    else if (O_ap_ready)
        ap_start <= auto_restart; // clear on handshake/auto restart
end

// ap_done
always @(posedge ACLK) begin
    if (~ARESETN)
        ap_done <= 1'b0;
    else if (O_ap_done)
        ap_done <= 1'b1;
    else if (ar_hs && raddr == ADDR_AP_CTRL)
        ap_done <= 1'b0; // clear on read
end

// auto_restart
always @(posedge ACLK) begin
    if (~ARESETN)
        auto_restart <= 1'b0;
    else if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0])
        auto_restart <=  WDATA[7];
end

// gie
always @(posedge ACLK) begin
    if (~ARESETN)
        gie <= 1'b0;
    else if (w_hs && waddr == ADDR_GIE && WSTRB[0])
        gie <= WDATA[0];
end

// ier
always @(posedge ACLK) begin
    if (~ARESETN)
        ier <= 1'b0;
    else if (w_hs && waddr == ADDR_IER && WSTRB[0])
        ier <= WDATA[1:0];
end

// isr[0]
always @(posedge ACLK) begin
    if (~ARESETN)
        isr[0] <= 1'b0;
    else if (ier[0] & O_ap_done)
        isr[0] <= 1'b1;
    else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
        isr[0] <= isr[0] ^ WDATA[0]; // toggle on write
end

// isr[1]
always @(posedge ACLK) begin
    if (~ARESETN)
        isr[1] <= 1'b0;
    else if (ier[1] & O_ap_ready)
        isr[1] <= 1'b1;
    else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
        isr[1] <= isr[1] ^ WDATA[1]; // toggle on write
end

// _rows[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_ROWS_DATA_0)
        _rows[31:0] <= (WDATA[31:0] & wmask) | (_rows[31:0] & ~wmask);
end

// _cols[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_COLS_DATA_0)
        _cols[31:0] <= (WDATA[31:0] & wmask) | (_cols[31:0] & ~wmask);
end

// _C_XR0C0[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR0C0_DATA_0)
        _C_XR0C0[31:0] <= (WDATA[31:0] & wmask) | (_C_XR0C0[31:0] & ~wmask);
end

// _C_XR0C1[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR0C1_DATA_0)
        _C_XR0C1[31:0] <= (WDATA[31:0] & wmask) | (_C_XR0C1[31:0] & ~wmask);
end

// _C_XR0C2[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR0C2_DATA_0)
        _C_XR0C2[31:0] <= (WDATA[31:0] & wmask) | (_C_XR0C2[31:0] & ~wmask);
end

// _C_XR1C0[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR1C0_DATA_0)
        _C_XR1C0[31:0] <= (WDATA[31:0] & wmask) | (_C_XR1C0[31:0] & ~wmask);
end

// _C_XR1C1[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR1C1_DATA_0)
        _C_XR1C1[31:0] <= (WDATA[31:0] & wmask) | (_C_XR1C1[31:0] & ~wmask);
end

// _C_XR1C2[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR1C2_DATA_0)
        _C_XR1C2[31:0] <= (WDATA[31:0] & wmask) | (_C_XR1C2[31:0] & ~wmask);
end

// _C_XR2C0[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR2C0_DATA_0)
        _C_XR2C0[31:0] <= (WDATA[31:0] & wmask) | (_C_XR2C0[31:0] & ~wmask);
end

// _C_XR2C1[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR2C1_DATA_0)
        _C_XR2C1[31:0] <= (WDATA[31:0] & wmask) | (_C_XR2C1[31:0] & ~wmask);
end

// _C_XR2C2[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_XR2C2_DATA_0)
        _C_XR2C2[31:0] <= (WDATA[31:0] & wmask) | (_C_XR2C2[31:0] & ~wmask);
end

// _C_YR0C0[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR0C0_DATA_0)
        _C_YR0C0[31:0] <= (WDATA[31:0] & wmask) | (_C_YR0C0[31:0] & ~wmask);
end

// _C_YR0C1[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR0C1_DATA_0)
        _C_YR0C1[31:0] <= (WDATA[31:0] & wmask) | (_C_YR0C1[31:0] & ~wmask);
end

// _C_YR0C2[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR0C2_DATA_0)
        _C_YR0C2[31:0] <= (WDATA[31:0] & wmask) | (_C_YR0C2[31:0] & ~wmask);
end

// _C_YR1C0[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR1C0_DATA_0)
        _C_YR1C0[31:0] <= (WDATA[31:0] & wmask) | (_C_YR1C0[31:0] & ~wmask);
end

// _C_YR1C1[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR1C1_DATA_0)
        _C_YR1C1[31:0] <= (WDATA[31:0] & wmask) | (_C_YR1C1[31:0] & ~wmask);
end

// _C_YR1C2[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR1C2_DATA_0)
        _C_YR1C2[31:0] <= (WDATA[31:0] & wmask) | (_C_YR1C2[31:0] & ~wmask);
end

// _C_YR2C0[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR2C0_DATA_0)
        _C_YR2C0[31:0] <= (WDATA[31:0] & wmask) | (_C_YR2C0[31:0] & ~wmask);
end

// _C_YR2C1[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR2C1_DATA_0)
        _C_YR2C1[31:0] <= (WDATA[31:0] & wmask) | (_C_YR2C1[31:0] & ~wmask);
end

// _C_YR2C2[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_YR2C2_DATA_0)
        _C_YR2C2[31:0] <= (WDATA[31:0] & wmask) | (_C_YR2C2[31:0] & ~wmask);
end

// _c_high_thesh[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_HIGH_THESH_DATA_0)
        _c_high_thesh[31:0] <= (WDATA[31:0] & wmask) | (_c_high_thesh[31:0] & ~wmask);
end

// _c_low_thresh[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_LOW_THRESH_DATA_0)
        _c_low_thresh[31:0] <= (WDATA[31:0] & wmask) | (_c_low_thresh[31:0] & ~wmask);
end

// _c_invert[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_C_INVERT_DATA_0)
        _c_invert[31:0] <= (WDATA[31:0] & wmask) | (_c_invert[31:0] & ~wmask);
end

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++

endmodule