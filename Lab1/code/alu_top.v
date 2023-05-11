`timescale 1ns/1ps
// 110652011

module alu_top(
    /* input */
    src1,       //1 bit, source 1 (A)
    src2,       //1 bit, source 2 (B)
    less,       //1 bit, less
    A_invert,   //1 bit, A_invert
    B_invert,   //1 bit, B_invert
    cin,        //1 bit, carry in
    operation,  //2 bit, operation
    /* output */
    result,     //1 bit, result
    cout        //1 bit, carry out
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input src1;
input src2;
input less;
input A_invert;
input B_invert;
input cin;
input [1:0] operation;

output result;
output cout;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg result, cout;

wire add_r, add_c; // result of adder, carry out of adder.

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

adder adder (
    .A(src1 ^ A_invert),
    .B(src2 ^ B_invert),
    .cin(cin),
    .result(add_r),
    .cout(add_c)
);

always@(*) begin

    case(operation)

        // and
        2'b00 : begin
            result = (src1 ^ A_invert) & (src2 ^ B_invert);
            cout = 0;
        end
        
        // or
        2'b01 : begin
            result = (src1 ^ A_invert) | (src2 ^ B_invert);
            cout = 0;
        end
        
        // add
        2'b10 : begin
            result = add_r;
            cout = add_c;
        end
        
        // less
        2'b11 : begin
            result = 0;
            cout = add_c;
        end

    endcase

end

endmodule
