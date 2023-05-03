//Subject:     CO project 3 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
	);
		
// I/O port
input         clk_i;
input         rst_i;

// Internal Signles--------------------------------------------------------------------------------

// program counter
wire    [32-1:0]  pc1, pc2, pc3, pc4;

// instruction
wire    [32-1:0]  ins;

// Decoder
wire              Reg_Write;
wire    [3-1:0]   ALUop;
wire              ALUsrc;
wire    [2-1:0]   Reg_Dst;
wire              Branch;
wire              Jump;
wire              MemtoReg;
wire              Branch_type;
wire              Mem_Read;
wire              Mem_Write;

// Register
wire    [ 6-1:0]  Write_Reg;
wire    [32-1:0]  Read_data1;
wire    [32-1:0]  Read_data2;
wire    [32-1:0]  Write_Data;

// ALU
wire    [4-1:0]   ALUCtrl;
wire    [32-1:0]  src2;
wire    [32-1:0]  ALU_result;
wire              ALU_zero;

// Extend
wire    [32-1:0] Extended;

// Shift left
wire    [32-1:0] Shifted;


// Greate componentes--------------------------------------------------------------------------------
ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc4),
	.pc_out_o(pc1)
	);

Adder Adder1(           // pc + 4
        .src1_i(pc1),
	.src2_i(4'd4),
	.sum_o(pc2)
	);

Instr_Memory IM(
        .pc_addr_i(pc1),
	.instr_o(ins)
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(ins[20:16]),
        .data1_i(ins[15:11]),
        .select_i(Reg_Dst),
        .data_o(Write_Reg)
        );

Reg_File Registers(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(ins[25:21]),
        .RTaddr_i(ins[20:16]),
        .RDaddr_i(Write_Reg),
        .RDdata_i(Write_Data),
        .RegWrite_i(Reg_Write),
        .RSdata_o(Read_data1),
        .RTdata_o(Read_data2)
        );

Decoder Decoder(
        .instr_op_i(ins[31:26]),
	.RegWrite_o(Reg_Write),
	.ALU_op_o(ALUop),
	.ALUSrc_o(ALUsrc),
	.RegDst_o(Reg_Dst),
	.Branch_o(Branch),
        .Jump_o(Jump),
        .MemtoReg_o(MemtoReg),
	.MemRead_o(Mem_Read),
	.MemWrite_o(Mem_Write)
	);

ALU_Ctrl AC(
        .funct_i(ins[5:0]),
        .ALUOp_i(ALUop),
        .ALUCtrl_o(ALUCtrl)
        );

Sign_Extend SE(
        .data_i(ins[15:0]),
        .data_o(Extended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(Read_data2),
        .data1_i(Extended),
        .select_i(ALUsrc),
        .data_o(src2)
        );

ALU ALU(
        .src1_i(Read_data1),
	.src2_i(src2),
	.ctrl_i(ALUCtrl),
	.result_o(ALU_result),
	.zero_o(ALU_zero)
	);

Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALU_result),
	.data_i(),
	.MemRead_i(),
	.MemWrite_i(),
	.data_o()
	);

MUX_4to1 #(.size()) Mux_WriteData(
        .data0_i(),
        .data1_i(),
        .data2_i(),
        .data3_i(),
        .select_i(),
        .data_o()
        );

Adder Adder2(
        .src1_i(),
	.src2_i(),
	.sum_o()
	);

Shift_Left_Two_32 Shifter(
        .data_i(),
        .data_o()
        ); 		

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	

endmodule