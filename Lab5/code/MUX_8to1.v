// 110652011
`timescale 1ns/1ps
module MUX_8to1(
        data0_i,
        data1_i,
        data2_i,
        data3_i,
        data4_i,
        data5_i,
        data6_i,
        data7_i,
        select_i,
        data_o
        );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [size-1:0] data3_i;
input   [size-1:0] data4_i;
input   [size-1:0] data5_i;
input   [size-1:0] data6_i;
input   [size-1:0] data7_i;
input      [3-1:0] select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function

    always @(*) begin
        case (select_i)
            0: data_o <= data0_i;
            1: data_o <= data1_i;
            2: data_o <= data2_i;
            3: data_o <= data3_i;
            4: data_o <= data4_i;
            5: data_o <= data5_i;
            6: data_o <= data6_i;
            7: data_o <= data7_i;
            default: ;
        endcase
    end

endmodule