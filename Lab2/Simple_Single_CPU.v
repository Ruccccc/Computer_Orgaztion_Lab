//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: Single cycle CPU
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

wire [32-1:0] pc1, pc2, pc3, pc4; // Program count // p1 +4 --> p2  +offset --> p3  // mux p2, p3 --> p4 --> p1
wire [32-1:0] instr;              // Instrction
wire  [3-1:0] ALUop;              // For ALU control.
wire          RegDst;             // Write rt or rd.
wire          RegWrite;           // Write register or not.
wire          ALUsrc;             // From register or instruction.
wire          branch;             // branch or not.
wire  [5-1:0] Write_reg;          // the register being write. (rt or rd)
wire  [4-1:0] ALUctrl;            // ALU control for ALU.
wire [32-1:0] extended, shifted;  // instruction[15:0] --> (extend to 32 bits) --> extended --> (shift left 2) --> shiifted.
wire [32-1:0] src1, rt, src2;     // rs // rt // mux extended, rt --> src2.
wire [32-1:0] ALU_result;         // Result of ALU.
wire          ALU_Zero;           // Result is zero.

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i (rst_i),
	.pc_in_i(pc4),
	.pc_out_o(pc1)
	);
	
Adder Adder1(
        .src1_i(pc1),
	.src2_i(32'd4),
	.sum_o(pc2)
	);

Instr_Memory IM(
        .pc_addr_i(pc1),
	.instr_o(instr)
	);
	
Decoder Decoder(
        .instr_op_i(instr[31:26]),
	.RegWrite_o(RegWrite),
	.ALU_op_o(ALUop),
	.ALUSrc_o(ALUsrc),
	.RegDst_o(RegDst),
	.Branch_o(branch)
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
        .RSdata_o(src1),
        .RTdata_o(rt)
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
        .src1_i(src1),
	.src2_i(src2),
	.ctrl_i(ALUctrl),
	.result_o(ALU_result),
	.zero_o(ALU_Zero)
	);
		
Adder Adder2(
        .src1_i(pc2),
	.src2_i(shifted),
	.sum_o(pc3)
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(extended),
        .data_o(shifted)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc2),
        .data1_i(pc3),
        .select_i((branch & ALU_Zero)),
        .data_o(pc4)
        );

endmodule