module axi_uart_bridge (
    input          clk,
    input          reset,

    // Slave Side (接你的 Lite2Full Bridge)
    input  [3:0]   s_awid,
    input  [31:0]  s_awaddr,
    input  [7:0]   s_awlen,
    input  [2:0]   s_awsize,
    input  [1:0]   s_awburst,
    input          s_awvalid,
    output         s_awready,

    input  [31:0]  s_wdata,
    input  [3:0]   s_wstrb,
    input          s_wlast,
    input          s_wvalid,
    output         s_wready,

    output [3:0]   s_bid,
    output [1:0]   s_bresp,
    output         s_bvalid,
    input          s_bready,

    input  [3:0]   s_arid,
    input  [31:0]  s_araddr,
    input  [7:0]   s_arlen,
    input  [2:0]   s_arsize,
    input  [1:0]   s_arburst,
    input          s_arvalid,
    output         s_arready,

    output [3:0]   s_rid,
    output [31:0]  s_rdata,
    output [1:0]   s_rresp,
    output         s_rlast,
    output         s_rvalid,
    input          s_rready,

    // Master Side (接 SoC io_master 接口)
    output [3:0]   m_awid,
    output [31:0]  m_awaddr,
    output [7:0]   m_awlen,
    output [2:0]   m_awsize,
    output [1:0]   m_awburst,
    output         m_awvalid,
    input          m_awready,

    output [31:0]  m_wdata,
    output [3:0]   m_wstrb,
    output         m_wlast,
    output         m_wvalid,
    input          m_wready,

    input  [3:0]   m_bid,
    input  [1:0]   m_bresp,
    input          m_bvalid,
    output         m_bready,

    output [3:0]   m_arid,
    output [31:0]  m_araddr,
    output [7:0]   m_arlen,
    output [2:0]   m_arsize,
    output [1:0]   m_arburst,
    output         m_arvalid,
    input          m_arready,

    input  [3:0]   m_rid,
    input  [31:0]  m_rdata,
    input  [1:0]   m_rresp,
    input          m_rlast,
    input          m_rvalid,
    output         m_rready
);

    // --- UART 地址判定 (根据你的需求调整基地址) ---
    // 假设 UART 范围是 0x1000_0000 ~ 0x1000_0FFF
    wire is_uart_aw = (s_awaddr[31:12] == 20'h10000);
    wire is_uart_ar = (s_araddr[31:12] == 20'h10000);

    // --- 写地址/写数据逻辑 ---
    assign m_awid    = s_awid;
    assign m_awaddr  = s_awaddr;
    assign m_awlen   = s_awlen;
    assign m_awburst = s_awburst;
    assign m_awvalid = s_awvalid;
    assign s_awready = m_awready;

    // 如果访问 UART，强制将 awsize 设为 1 字节 (3'b000)，触发 SoC 兼容逻辑
    assign m_awsize  = is_uart_aw ? 3'b000 : s_awsize;

    // 核心写逻辑：字节重分布
    // 当写 UART 时，把有效字节复制到 [7:0], [15:8], [23:16], [31:24]
    wire [7:0] uart_byte = s_wstrb[0] ? s_wdata[7:0]   :
                           s_wstrb[1] ? s_wdata[15:8]  :
                           s_wstrb[2] ? s_wdata[23:16] : s_wdata[31:24];

    assign m_wdata   = is_uart_aw ? {4{uart_byte}} : s_wdata;
    assign m_wstrb   = is_uart_aw ? 4'b1111 : s_wstrb;
    assign m_wlast   = s_wlast;
    assign m_wvalid  = s_wvalid;
    assign s_wready  = m_wready;

    // 写响应通道直接透传
    assign s_bid     = m_bid;
    assign s_bresp   = m_bresp;
    assign s_bvalid  = m_bvalid;
    assign m_bready  = s_bready;

    // --- 读地址逻辑 ---
    assign m_arid    = s_arid;
    assign m_araddr  = s_araddr;
    assign m_arlen   = s_arlen;
    assign m_arburst = s_arburst;
    assign m_arvalid = s_arvalid;
    assign s_arready = m_arready;

    // 如果读的是 UART，建议也将 arsize 设为 1 字节
    assign m_arsize  = is_uart_ar ? 3'b000 : s_arsize;

    // --- 读数据逻辑 ---
    // 需要记录当前读事务是否发往 UART，以便在数据返回时处理
    // 由于是 AXI-Lite 转换过来的，通常同一时间只有一个在途读请求
    reg is_uart_read_active;
    always @(posedge clk) begin
        if (reset) begin
            is_uart_read_active <= 1'b0;
        end else begin
            if (s_arvalid && s_arready)
                is_uart_read_active <= is_uart_ar;
            else if (s_rvalid && s_rready && s_rlast)
                is_uart_read_active <= 1'b0;
        end
    end

    assign s_rid     = m_rid;
    assign s_rresp   = m_rresp;
    assign s_rlast   = m_rlast;
    assign s_rvalid  = m_rvalid;
    assign m_rready  = s_rready;

    // 核心读逻辑：字节广播
    // 如果是 UART 读，把返回的 m_rdata[7:0] 复制到所有 4 个字节槽
    // 这样 CPU 的 lb/lh/lw 指令无论怎么选都能读到数据
    assign s_rdata   = is_uart_read_active ? {4{m_rdata[7:0]}} : m_rdata;

endmodule
