//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: According to instruction, assign the singles to other part of CPU.
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg            RegWrite_o; // write register
reg    [3-1:0] ALU_op_o;   // operator of ALU control
reg            ALUSrc_o;   // 1 if from register, 0 if from instruction
reg            RegDst_o;   // write rt or rd, 1 for rd, 0 for rt
reg            Branch_o;   // 1 if branch

//Parameter


//Main function

	always @(instr_op_i) begin
		case (instr_op_i)

			0: begin 			 // R-type
				RegWrite_o <= 1; // write
				ALU_op_o   <= 0; // accroding to function field
				ALUSrc_o   <= 0; // from register
				RegDst_o   <= 1; // write rd
				Branch_o   <= 0; // not branch
			end

			4: begin 			 // beq
				RegWrite_o <= 0; // not write
				ALU_op_o   <= 1; // sub
				ALUSrc_o   <= 0; // from register
				RegDst_o   <= 0; 
				Branch_o   <= 1; // branch
			end

			8: begin 			 // addi
				RegWrite_o <= 1; // write
				ALU_op_o   <= 2; // add
				ALUSrc_o   <= 1; // from instruction
				RegDst_o   <= 0; // write rt
				Branch_o   <= 0; // not branch
			end

			10: begin			 // slti
				RegWrite_o <= 1; // write
				ALU_op_o   <= 3; // slt
				ALUSrc_o   <= 1; // from instruction
				RegDst_o   <= 0; // write rt
				Branch_o   <= 0; // not branch
			end

			default: begin
				RegWrite_o <= 0;
				ALU_op_o   <= 0;
				ALUSrc_o   <= 0;
				RegDst_o   <= 0;
				Branch_o   <= 0;
			end
		endcase
		
	end

endmodule





                    
                    