`timescale 1ns/1ps
// 110652011
module alu(
    /* input */
    clk,            // system clock
    rst_n,          // negative reset
    src1,           // 32 bits, source 1
    src2,           // 32 bits, source 2
    ALU_control,    // 4 bits, ALU control input
    /* output */
    result,         // 32 bits, result
    zero,           // 1 bit, set to 1 when the output is 0
    cout,           // 1 bit, carry out
    overflow        // 1 bit, overflow
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk;
input rst_n;
input [31:0] src1;
input [31:0] src2;
input [3:0] ALU_control;

output [32-1:0] result;
output zero;
output cout;
output overflow;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg [32-1:0] result;
reg zero, cout, overflow;

wire [32-1:0] r;   // the result of alu_top.
wire [31:0]   co;  // carry out of alu_top.

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin

        for (integer i = 0; i < 32; i++) begin
            result[i] = 0;
        end
        zero = 0;
        cout = 0;
        overflow = 0;

	end
	else begin

        case (ALU_control)

            // AND
            4'b0000 : begin
                
                for (integer i = 0; i < 32; i++) begin
                    result[i] <= r[i];
                end
                zero = (r === 32'd0);
                cout = 0;
                overflow = 0;

            end

            // OR
            4'b0001 : begin
                
                for (integer i = 0; i < 32; i++) begin
                    result[i] <= r[i];
                end
                zero = (r === 32'd0);
                cout = 0;
                overflow = 0;

            end

            // ADD
            4'b0010 : begin

                for (integer i = 0; i < 32; i++) begin
                    result[i] <= r[i];
                end
                zero = (r === 32'd0);
                cout = co[31];
                overflow = co[30] ^ co[31];

            end

            // SUB
            4'b0110 : begin

                for (integer i = 0; i < 32; i++) begin
                    result[i] <= r[i];
                end
                zero = (r === 32'd0);
                cout = co[31];
                overflow = co[30] ^ co[31];

            end

            // NOR
            4'b1100 : begin
                
                for (integer i = 0; i < 32; i++) begin
                    result[i] <= r[i];
                end
                zero = (r === 32'd0);
                cout = 0;
                overflow = 0;

            end

            // set less then
            4'b0111 : begin

                for (integer i = 1; i < 32; i++) begin
                    result[i] <= 0;
                end
                result[0] <= co[31];
                zero = (result === 32'd0);
                cout = 0;
                overflow = 0;

            end

        endcase

	end
end

// 32-bit ALU
alu_top ALU00(.src1(src1[ 0]), .src2(src2[ 0]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(ALU_control[2]), .operation(ALU_control[1:0]), .result(r[ 0]), .cout(co[ 0]));
alu_top ALU01(.src1(src1[ 1]), .src2(src2[ 1]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 0]), .operation(ALU_control[1:0]), .result(r[ 1]), .cout(co[ 1]));
alu_top ALU02(.src1(src1[ 2]), .src2(src2[ 2]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 1]), .operation(ALU_control[1:0]), .result(r[ 2]), .cout(co[ 2]));
alu_top ALU03(.src1(src1[ 3]), .src2(src2[ 3]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 2]), .operation(ALU_control[1:0]), .result(r[ 3]), .cout(co[ 3]));
alu_top ALU04(.src1(src1[ 4]), .src2(src2[ 4]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 3]), .operation(ALU_control[1:0]), .result(r[ 4]), .cout(co[ 4]));
alu_top ALU05(.src1(src1[ 5]), .src2(src2[ 5]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 4]), .operation(ALU_control[1:0]), .result(r[ 5]), .cout(co[ 5]));
alu_top ALU06(.src1(src1[ 6]), .src2(src2[ 6]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 5]), .operation(ALU_control[1:0]), .result(r[ 6]), .cout(co[ 6]));
alu_top ALU07(.src1(src1[ 7]), .src2(src2[ 7]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 6]), .operation(ALU_control[1:0]), .result(r[ 7]), .cout(co[ 7]));
alu_top ALU08(.src1(src1[ 8]), .src2(src2[ 8]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 7]), .operation(ALU_control[1:0]), .result(r[ 8]), .cout(co[ 8]));
alu_top ALU09(.src1(src1[ 9]), .src2(src2[ 9]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 8]), .operation(ALU_control[1:0]), .result(r[ 9]), .cout(co[ 9]));
alu_top ALU10(.src1(src1[10]), .src2(src2[10]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[ 9]), .operation(ALU_control[1:0]), .result(r[10]), .cout(co[10]));
alu_top ALU11(.src1(src1[11]), .src2(src2[11]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[10]), .operation(ALU_control[1:0]), .result(r[11]), .cout(co[11]));
alu_top ALU12(.src1(src1[12]), .src2(src2[12]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[11]), .operation(ALU_control[1:0]), .result(r[12]), .cout(co[12]));
alu_top ALU13(.src1(src1[13]), .src2(src2[13]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[12]), .operation(ALU_control[1:0]), .result(r[13]), .cout(co[13]));
alu_top ALU14(.src1(src1[14]), .src2(src2[14]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[13]), .operation(ALU_control[1:0]), .result(r[14]), .cout(co[14]));
alu_top ALU15(.src1(src1[15]), .src2(src2[15]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[14]), .operation(ALU_control[1:0]), .result(r[15]), .cout(co[15]));
alu_top ALU16(.src1(src1[16]), .src2(src2[16]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[15]), .operation(ALU_control[1:0]), .result(r[16]), .cout(co[16]));
alu_top ALU17(.src1(src1[17]), .src2(src2[17]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[16]), .operation(ALU_control[1:0]), .result(r[17]), .cout(co[17]));
alu_top ALU18(.src1(src1[18]), .src2(src2[18]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[17]), .operation(ALU_control[1:0]), .result(r[18]), .cout(co[18]));
alu_top ALU19(.src1(src1[19]), .src2(src2[19]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[18]), .operation(ALU_control[1:0]), .result(r[19]), .cout(co[19]));
alu_top ALU20(.src1(src1[20]), .src2(src2[20]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[19]), .operation(ALU_control[1:0]), .result(r[20]), .cout(co[20]));
alu_top ALU21(.src1(src1[21]), .src2(src2[21]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[20]), .operation(ALU_control[1:0]), .result(r[21]), .cout(co[21]));
alu_top ALU22(.src1(src1[22]), .src2(src2[22]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[21]), .operation(ALU_control[1:0]), .result(r[22]), .cout(co[22]));
alu_top ALU23(.src1(src1[23]), .src2(src2[23]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[22]), .operation(ALU_control[1:0]), .result(r[23]), .cout(co[23]));
alu_top ALU24(.src1(src1[24]), .src2(src2[24]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[23]), .operation(ALU_control[1:0]), .result(r[24]), .cout(co[24]));
alu_top ALU25(.src1(src1[25]), .src2(src2[25]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[24]), .operation(ALU_control[1:0]), .result(r[25]), .cout(co[25]));
alu_top ALU26(.src1(src1[26]), .src2(src2[26]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[25]), .operation(ALU_control[1:0]), .result(r[26]), .cout(co[26]));
alu_top ALU27(.src1(src1[27]), .src2(src2[27]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[26]), .operation(ALU_control[1:0]), .result(r[27]), .cout(co[27]));
alu_top ALU28(.src1(src1[28]), .src2(src2[28]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[27]), .operation(ALU_control[1:0]), .result(r[28]), .cout(co[28]));
alu_top ALU29(.src1(src1[29]), .src2(src2[29]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[28]), .operation(ALU_control[1:0]), .result(r[29]), .cout(co[29]));
alu_top ALU30(.src1(src1[30]), .src2(src2[30]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[29]), .operation(ALU_control[1:0]), .result(r[30]), .cout(co[30]));
alu_top ALU31(.src1(src1[31]), .src2(src2[31]), .less(), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(        co[30]), .operation(ALU_control[1:0]), .result(r[31]), .cout(co[31]));

endmodule
