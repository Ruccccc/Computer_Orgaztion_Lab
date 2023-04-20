//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
	rst_i
	);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

wire [32-1:0] pc1, pc2, pc3, pc4; // program count // pc2 -> pc1 + 4 // pc3 -> pc2 + offset // pc4 -> mux pc2, pc3
wire [32-1:0] instr;              // instrction
wire  [3-1:0] ALUop;
wire          RegDst;
wire          RegWrite;
wire          ALUsrc;
wire          branch;
wire  [5-1:0] Write_reg;
wire  [4-1:0] ALUctrl;
wire [32-1:0] extended, extended_and_shifted;
wire [32-1:0] rs, rt, src2;
wire [32-1:0] ALU_result;
wire          ALU_Zero;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i (rst_i),
	.pc_in_i(pc4),
	.pc_out_o(pc1)
	);
	
Adder Adder1(            // pc + 4
        .src1_i(pc1),
	.src2_i(32'd4),
	.sum_o(pc2)
	);

Instr_Memory IM(
        .pc_addr_i(pc1),
	.instr_o(instr)
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(Write_reg)
        );
		
Reg_File RF(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(Write_reg),
        .RDdata_i(ALU_result),
        .RegWrite_i(RegWrite),
        .RSdata_o(rs),
        .RTdata_o(rt)
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]),
	.RegWrite_o(RegWrite),
	.ALU_op_o(ALUop),
	.ALUSrc_o(ALUsrc),
	.RegDst_o(RegDst),
	.Branch_o(branch)
	);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),
        .ALUOp_i(ALUop),
        .ALUCtrl_o(ALUctrl)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(extended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rt),
        .data1_i(extended),
        .select_i(ALUsrc),
        .data_o(src2)
        );
		
ALU ALU(
        .src1_i(rs),
	.src2_i(src2),
	.ctrl_i(ALUctrl),
	.result_o(ALU_result),
	.zero_o(ALU_Zero)
	);
		
Adder Adder2( // add pc and offset
        .src1_i(pc2),
	.src2_i(extended_and_shifted),
	.sum_o(pc3)
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(extended),
        .data_o(extended_and_shifted)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc2),
        .data1_i(pc3),
        .select_i((branch & ALU_Zero)),
        .data_o(pc4)
        );

endmodule