module axi_uart_psram_bridge #(
    // 你可以根据你的 SoC 地址空间划分修改这些参数
    parameter UART_BASE  = 32'h10000000,
    parameter UART_MASK  = 32'hFFFF0000,
    parameter PSRAM_BASE = 32'h80000000,
    parameter PSRAM_MASK = 32'hFF000000
)(
    input          clk,
    input          reset,

    // Slave Side (接前端的 AXI-Lite 转 AXI-Full 桥或 CPU)
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

    // Master Side (接 SoC io_master / 设备端)
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

    // =========================================================================
    // 写入控制与 Read-Modify-Write (RMW) 状态机
    // =========================================================================
    localparam W_IDLE      = 3'd0,
               W_RMW_AR    = 3'd1,
               W_RMW_R     = 3'd2,
               W_SEND_AW_W = 3'd3,
               W_WAIT_B    = 3'd4;

    reg [2:0]  w_state;
    reg        aw_full, w_full;
    reg        aw_sent, w_sent;

    // AXI 写入请求缓存寄存器
    reg [3:0]  r_awid;
    reg [31:0] r_awaddr;
    reg [7:0]  r_awlen;
    reg [2:0]  r_awsize;
    reg [1:0]  r_awburst;
    reg [31:0] r_wdata;
    reg [3:0]  r_wstrb;
    reg        r_wlast;

    // 清除缓存请求的标志
    wire clear_req = (w_state == W_WAIT_B && m_bvalid && s_bready);

    assign s_awready = ~aw_full;
    assign s_wready  = ~w_full;

    // 捕获 AW 和 W 通道数据
    always @(posedge clk) begin
        if (reset) begin
            aw_full <= 0; w_full <= 0;
        end else begin
            if (s_awvalid && s_awready) begin
                aw_full <= 1;
                r_awid <= s_awid;     r_awaddr <= s_awaddr;
                r_awlen <= s_awlen;   r_awsize <= s_awsize;
                r_awburst <= s_awburst;
            end
            if (s_wvalid && s_wready) begin
                w_full <= 1;
                r_wdata <= s_wdata;   r_wstrb <= s_wstrb;
                r_wlast <= s_wlast;
            end
            if (clear_req) begin
                aw_full <= 0; w_full <= 0;
            end
        end
    end

    // 判别逻辑
    wire req_ready  = aw_full && w_full;
    wire is_uart_aw = ((r_awaddr & UART_MASK) == UART_BASE);
    wire is_psram_aw= ((r_awaddr & PSRAM_MASK) == PSRAM_BASE);
    wire is_narrow  = (r_wstrb != 4'b1111);
    wire needs_rmw  = is_psram_aw && is_narrow;

    // 读写通道互斥信号（确保 RMW 读操作时，阻止新的 CPU 读操作发往从机）
    wire rmw_active  = (w_state == W_RMW_AR) || (w_state == W_RMW_R);
    reg  cpu_read_pending; // 用于检测 CPU 是否有还没回来的读请求
    wire safe_to_rmw = !cpu_read_pending; 

    // RMW 修改后的数据缓存
    reg [31:0] modified_wdata;

    // 核心写入 FSM
    always @(posedge clk) begin
        if (reset) begin
            w_state <= W_IDLE;
            aw_sent <= 0;
            w_sent <= 0;
        end else case (w_state)
            W_IDLE: begin
                aw_sent <= 0; w_sent <= 0;
                if (req_ready) begin
                    if (needs_rmw) begin
                        if (safe_to_rmw) w_state <= W_RMW_AR; // 只有在无 CPU 读请求冲突时才发起 RMW
                    end else begin
                        w_state <= W_SEND_AW_W; // 满位直接写，或发给非 PSRAM 外设
                    end
                end
            end
            W_RMW_AR: if (m_arready) w_state <= W_RMW_R;
            W_RMW_R:  begin
                if (m_rvalid) begin
                    // 获取基地址读回的数据，并将其与我们要写入的新字节结合
                    modified_wdata[7:0]   <= r_wstrb[0] ? r_wdata[7:0]   : m_rdata[7:0];
                    modified_wdata[15:8]  <= r_wstrb[1] ? r_wdata[15:8]  : m_rdata[15:8];
                    modified_wdata[23:16] <= r_wstrb[2] ? r_wdata[23:16] : m_rdata[23:16];
                    modified_wdata[31:24] <= r_wstrb[3] ? r_wdata[31:24] : m_rdata[31:24];
                    w_state <= W_SEND_AW_W;
                end
            end
            W_SEND_AW_W: begin
                if (m_awready) aw_sent <= 1;
                if (m_wready)  w_sent <= 1;
                if ((m_awready || aw_sent) && (m_wready || w_sent)) begin
                    w_state <= W_WAIT_B;
                end
            end
            W_WAIT_B: if (m_bvalid && s_bready) w_state <= W_IDLE;
            default: w_state <= W_IDLE;
        endcase
    end

    // Master 侧写地址与数据输出路由
    wire [7:0] uart_byte = r_wstrb[0] ? r_wdata[7:0]   :
                           r_wstrb[1] ? r_wdata[15:8]  :
                           r_wstrb[2] ? r_wdata[23:16] : r_wdata[31:24];

    assign m_awvalid = (w_state == W_SEND_AW_W) && !aw_sent;
    assign m_wvalid  = (w_state == W_SEND_AW_W) && !w_sent;

    assign m_awid    = r_awid;
    // PSRAM RMW 强制 4 字节对齐
    assign m_awaddr  = needs_rmw ? {r_awaddr[31:2], 2'b00} : r_awaddr;
    assign m_awlen   = r_awlen;
    assign m_awsize  = is_uart_aw ? 3'b000 : needs_rmw ? 3'b010 : r_awsize;
    assign m_awburst = r_awburst;

    assign m_wdata   = is_uart_aw ? {4{uart_byte}} : needs_rmw ? modified_wdata : r_wdata;
    // UART 和 PSRAM(RMW 后) 都强制满掩码
    assign m_wstrb   = (is_uart_aw || needs_rmw) ? 4'b1111 : r_wstrb;
    assign m_wlast   = r_wlast;

    // Master 写响应通道透传
    assign s_bvalid  = (w_state == W_WAIT_B) ? m_bvalid : 1'b0;
    assign s_bid     = m_bid;
    assign s_bresp   = m_bresp;
    assign m_bready  = (w_state == W_WAIT_B) ? s_bready : 1'b0;


    // =========================================================================
    // 读通道多路复用：处理常规 CPU 读取 与 RMW 的后台读取
    // =========================================================================
    wire is_uart_ar = ((s_araddr & UART_MASK) == UART_BASE);
    reg  cpu_read_is_uart;

    // CPU 读取状态追踪（拦截 RMW 期间发起的正常读取，防止重叠）
    wire cpu_ar_fire = !rmw_active && s_arvalid && m_arready;
    wire cpu_r_fire  = !rmw_active && m_rvalid && m_rready && m_rlast;

    always @(posedge clk) begin
        if (reset) begin
            cpu_read_pending <= 0;
            cpu_read_is_uart <= 0;
        end else begin
            if (cpu_ar_fire && !cpu_r_fire) begin
                cpu_read_pending <= 1;
                cpu_read_is_uart <= is_uart_ar;
            end else if (!cpu_ar_fire && cpu_r_fire) begin
                cpu_read_pending <= 0;
            end else if (cpu_ar_fire && cpu_r_fire) begin
                cpu_read_is_uart <= is_uart_ar;
            end
        end
    end

    // Master 侧读请求通道多路选择 (RMW 优先级绝对高于 CPU 正常读取)
    assign m_arvalid = rmw_active ? (w_state == W_RMW_AR) : s_arvalid;
    assign s_arready = rmw_active ? 1'b0 : m_arready; // RMW 期间阻塞 CPU 发送新读请求

    assign m_arid    = rmw_active ? r_awid : s_arid;
    assign m_araddr  = rmw_active ? {r_awaddr[31:2], 2'b00} : s_araddr;
    assign m_arlen   = rmw_active ? 8'd0 : s_arlen;
    // RMW 读取大小固定为 4 字节 (3'b010)
    assign m_arsize  = rmw_active ? 3'b010 : is_uart_ar ? 3'b000 : s_arsize;
    assign m_arburst = rmw_active ? 2'b01  : s_arburst;

    // 返回数据通道路由分离
    assign m_rready  = rmw_active ? (w_state == W_RMW_R) : s_rready;
    assign s_rvalid  = m_rvalid && !rmw_active;

    assign s_rid     = m_rid;
    assign s_rresp   = m_rresp;
    assign s_rlast   = m_rlast;
    
    // 如果是正常的 UART 读取，做数据总线重分布；如果是正常的 PSRAM，直接透传回 CPU
    assign s_rdata   = cpu_read_is_uart ? {4{m_rdata[7:0]}} : m_rdata;

endmodule
