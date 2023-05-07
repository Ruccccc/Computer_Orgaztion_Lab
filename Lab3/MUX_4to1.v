//Subject:     CO project 3 - MUX 321
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: Select the signal pass.
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module MUX_4to1(
        data0_i,
        data1_i,
        data2_i,
        data3_i,
        select_i,
        data_o
        );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [size-1:0] data3_i;
input      [2-1:0] select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function

    always @(data0_i, data1_i, data2_i, data3_i, select_i) begin
        case (select_i)
            0: data_o <= data0_i;
            1: data_o <= data1_i;
            2: data_o <= data2_i;
            3: data_o <= data3_i;
            default: ;
        endcase
    end

endmodule