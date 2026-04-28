`include "bus_define.vh"
module hazard_unit (
    input  [`REG_ADDR_WIDTH-1:0] rs1_addr_id,
    input  [`REG_ADDR_WIDTH-1:0] rs2_addr_id,

    input  [`REG_ADDR_WIDTH-1:0] rs1_addr_ex,
    input  [`REG_ADDR_WIDTH-1:0] rs2_addr_ex,
    input  [`REG_ADDR_WIDTH-1:0] rd_addr_ex,
    input                        mem_re_ex,       // EX阶段指令是否是 Load 指令 (idu_mem_re)
    input                        branch_taken_ex, // EX阶段是否发生跳转 (branch_taken)

    input  [`REG_ADDR_WIDTH-1:0] rd_addr_mem,
    input                        reg_we_mem,      // MEM阶段指令是否写回寄存器

    input  [`REG_ADDR_WIDTH-1:0] rd_addr_wb,
    input                        reg_we_wb,       // WB阶段指令是否写回寄存器

    input                        ifu_stall_req,   // IFU 正在等待指令内存返回数据
    input                        lsu_stall_req,   // LSU 正在等待数据内存读写完成

    output                       stall_pc,
    output                       stall_if_id,
    output                       stall_id_ex,
    output                       stall_ex_mem,
    output                       stall_mem_wb,

    output                       flush_if_id,
    output                       flush_id_ex,
    output                       flush_ex_mem,
    output                       flush_mem_wb,

    output reg [1:0]             forward_a, // 00:使用ID/EX里的原值, 01:从MEM前递, 10:从WB前递
    output reg [1:0]             forward_b
);

    // --------------------------------------------------------------------
    // [逻辑 1] 数据冒险：旁路前递 (Data Hazard & Forwarding)
    // --------------------------------------------------------------------
    // 解决 EX 阶段源操作数依赖 MEM 阶段或 WB 阶段结果的问题。
    always @(*) begin
        // 默认不前递，使用原本从寄存器堆读出的值
        forward_a = 2'b00;
        forward_b = 2'b00;

        // --- rs1 前递判断 ---
        if (reg_we_mem && (rd_addr_mem != 5'b0) 
			&& (rd_addr_mem == rs1_addr_ex)) begin
            	forward_a = 2'b01; // 第一优先级：紧挨着它的前一条指令 (从 MEM 阶段前递)
        end 
		else if (reg_we_wb && (rd_addr_wb != 5'b0) 
			&& (rd_addr_wb == rs1_addr_ex)) begin
            	forward_a = 2'b10; // 第二优先级：前两条指令 (从 WB 阶段前递)
        end

        // --- rs2 前递判断 ---
        if (reg_we_mem && (rd_addr_mem != 5'b0) 
			&& (rd_addr_mem == rs2_addr_ex)) begin
            	forward_b = 2'b01; 
        end 
		else if (reg_we_wb && (rd_addr_wb != 5'b0) 
			&& (rd_addr_wb == rs2_addr_ex)) begin
            	forward_b = 2'b10;
        end
    end

    // --------------------------------------------------------------------
    // [逻辑 2] Load-Use 冒险：停顿一拍 (Load-Use Hazard)
    // --------------------------------------------------------------------
    // 当前一条指令是 Load(在 EX)，且它的目标是后一条指令(在 ID)的源寄存器。
    // 因为 Load 的数据必须等到 MEM 级以后才有，来不及前递，必须停一拍。
    wire load_use_hazard;
    assign load_use_hazard = mem_re_ex && (rd_addr_ex != 5'b0) 
	&& ((rd_addr_ex == rs1_addr_id) || (rd_addr_ex == rs2_addr_id));

    // --------------------------------------------------------------------
    // [逻辑 3] 停顿与冲刷综合逻辑 (Stall & Flush)
    // --------------------------------------------------------------------
    // 优先级原则：LSU停顿会锁死整条流水线；分支冲刷(Branch Flush)具有极高的清零优先度。

    // PC 停顿：遇到 LSU 等待、IFU 等待、或者 Load-Use 冒险都需要停止更新 PC
    assign stall_pc      = lsu_stall_req | ifu_stall_req | load_use_hazard;

    // IF/ID 寄存器停顿与冲刷：
    // IFU 在等数据，或遇到了 Load-use，IF/ID 都要停顿保持原值
    assign stall_if_id   = lsu_stall_req | ifu_stall_req | load_use_hazard;
    // 一旦分支生效，清空还没执行的指令
    assign flush_if_id   = branch_taken_ex;

    // ID/EX 寄存器停顿与冲刷：
    // 如果 IFU 没数据(导致IF/ID里的指令失效)，或者遇到 Load-Use，需要向下塞入气泡(Flush)
    assign stall_id_ex   = lsu_stall_req;
    assign flush_id_ex   = branch_taken_ex | load_use_hazard | (ifu_stall_req & !lsu_stall_req);

    // EX/MEM 寄存器停顿与冲刷：
    assign stall_ex_mem  = lsu_stall_req;
    assign flush_ex_mem  = 1'b0; // 如果在 EX 计算完才冲刷，它自己不用被清空

    // MEM/WB 寄存器停顿与冲刷：
    assign stall_mem_wb  = lsu_stall_req;
    assign flush_mem_wb  = 1'b0;

endmodule
