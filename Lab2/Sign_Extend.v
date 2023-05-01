//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: Extent 16-bits sign to 32-bits
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;
integer i;

//Sign extended

always @(data_i) begin
    for (i = 0; i < 16; i = i + 1) begin
        data_o[i] = data_i[i];
    end
    for (i = 16; i < 32; i = i + 1) begin
        data_o[i] = data_i[15];
    end
end
          
endmodule
