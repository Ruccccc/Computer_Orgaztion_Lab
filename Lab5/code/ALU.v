// 110652011
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o,
	pos_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;
output 			 pos_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;
wire			 pos_o;

//Parameter

//Main function

	assign zero_o = (result_o == 0);
	assign pos_o = !(result_o[31]) & result_o != 0;
	always @(*) begin
		case (ctrl_i)
			0:	result_o <= src1_i & src2_i;			// and
			1:  result_o <= src1_i | src2_i; 		 	// or
			2:  result_o <= src1_i + src2_i; 		 	// add
			6:  result_o <= src1_i - src2_i; 		 	// sub
			7:  result_o <= src1_i < src2_i ? 1 : 0; 	// slt
			12: result_o <= ~(src1_i | src2_i);		 	// nor
			13:	result_o <= src1_i * src2_i;		 	// mult
			14:	result_o <= src1_i ^ src2_i;			// xor
			default: result_o <= 0;
		endcase
	end

endmodule





                    
                    