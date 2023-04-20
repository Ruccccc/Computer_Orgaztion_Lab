//Subject:     CO project 2 - Adder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: Set sum_o src1 add src2
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
wire   [32-1:0]	 sum_o;

//Parameter
    
//Main function

	assign sum_o = src1_i + src2_i;

endmodule





                    
                    