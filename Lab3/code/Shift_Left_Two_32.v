//Subject:      CO project 2 - Shift_Left_Two_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Description: <<= 2
//--------------------------------------------------------------------------------

module Shift_Left_Two_32(
    data_i,
    data_o
    );

//I/O ports                    
input   [32-1:0]    data_i;
output  [32-1:0]    data_o;

reg     [32-1:0]    data_o;

//shift left 2

always @(data_i) begin
    data_o <= data_i << 2;
end
     
endmodule
