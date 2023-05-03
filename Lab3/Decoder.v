//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o
	);
     
//I/O ports
input  	[6-1:0] instr_op_i;

output         	RegWrite_o;
output	[3-1:0] ALU_op_o;
output         	ALUSrc_o;
output 	[2-1:0] RegDst_o;
output         	Branch_o;
output 		   	Jump_o;
output 		   	MemtoReg_o;
output 		   	MemRead_o;
output         	MeMWrite;
 
//Internal Signals
reg		[3-1:0] ALU_op_o;
reg				ALUSrc_o;
reg				RegWrite_o;
reg		[2-1:0] RegDst_o;
reg 			Branch_o;
reg 			Jump_o;
reg		[2-1:0]	MemtoReg_o;
reg 			MemRead_o;
reg				MeMWrite;

//Parameter


//Main function

	always @(instr_op_i) begin
		case (instr_op_i)

			0: begin			 // R-type
				RegWrite_o <= 1; // write
				ALU_op_o   <= 2; // accroding to function field
				ALUSrc_o   <= 0; // from register
				RegDst_o   <= 1; // write rd
				Branch_o   <= 0; // not branch
				Jump_o	   <= 0; // not jump
				MemtoReg_o <= 0; // ALU result
				MemRead_o  <= 0; // No read
				MeMWrite   <= 0; // No write
			end

			2: begin 			 // Jump
				RegWrite_o <= 0; // not write
				ALU_op_o   <= 0; // Don't do
				ALUSrc_o   <= 0; // Don't care;
				RegDst_o   <= 0; // Don't care;
				Branch_o   <= 0; // Branch
				Jump_o	   <= 1; // jump
				MemtoReg_o <= 0; // Don't care
				MemRead_o  <= 0; // No read
				MeMWrite   <= 0; // No write
			end

			3: begin			 // jal -> write pc to Reg[31] and {pc[31:28], address<<2} to pc
				RegWrite_o <= 1; // write pc
				ALU_op_o   <= 0; // Don't care
				ALUSrc_o   <= 0; // Don't care
				RegDst_o   <= 3; // write register[31]
				Branch_o   <= 0; // not branch
				Jump_o	   <= 1; // jump
				MemtoReg_o <= 3; // pc
				MemRead_o  <= 0; // No read
				MeMWrite   <= 0; // No write
			end

			4: begin 			 // beq
				RegWrite_o <= 0; // not write
				ALU_op_o   <= 1; // sub
				ALUSrc_o   <= 0; // from register
				RegDst_o   <= 0; // Don't care
				Branch_o   <= 1; // branch
				Jump_o	   <= 0; // not jump
				MemtoReg_o <= 0; // Don't care
				MemRead_o  <= 0; // No read
				MeMWrite   <= 0; // No write
			end

			8: begin 			 // addi
				RegWrite_o <= 1; // write
				ALU_op_o   <= 0; // add
				ALUSrc_o   <= 1; // from instruction
				RegDst_o   <= 0; // write rt
				Branch_o   <= 0; // not branch
				Jump_o	   <= 0; // not jump
				MemtoReg_o <= 0; // ALU result
				MemRead_o  <= 0; // No read
				MeMWrite   <= 0; // No write
			end

			10: begin			 // slti
				RegWrite_o <= 1; // write
				ALU_op_o   <= 3; // slt
				ALUSrc_o   <= 1; // From instruction
				RegDst_o   <= 0; // write rt
				Branch_o   <= 0; // not branch
				Jump_o	   <= 0; // not jump
				MemtoReg_o <= 0; // ALU result
				MemRead_o  <= 0; // No read
				MeMWrite   <= 0; // No write
			end

			35: begin			 // lw
				RegWrite_o <= 1; // write
				ALU_op_o   <= 0; // add
				ALUSrc_o   <= 1; // From instruction
				RegDst_o   <= 0; // write rt
				Branch_o   <= 0; // not branch
				Jump_o	   <= 0; // not jump
				MemtoReg_o <= 1; // Memory
				MemRead_o  <= 1; // read memory
				MeMWrite   <= 0; // No write
			end

			43: begin			 // sw
				RegWrite_o <= 0; // not write
				ALU_op_o   <= 0; // Add
				ALUSrc_o   <= 1; // From instruction
				RegDst_o   <= 0; // Don't care
				Branch_o   <= 0; // not branch
				Jump_o	   <= 0; // not jump
				MemtoReg_o <= 0; // Don't care
				MemRead_o  <= 0; // No read
				MeMWrite   <= 1; // write memory
			end

			default: begin
				RegWrite_o <= 0;
				ALU_op_o   <= 0;
				ALUSrc_o   <= 0;
				RegDst_o   <= 0;
				Branch_o   <= 0;
				Jump_o	   <= 0;
				MemtoReg_o <= 0;
				MemRead_o  <= 0;
				MeMWrite   <= 0;
			end
		endcase
	end

endmodule
