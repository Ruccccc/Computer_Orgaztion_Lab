`timescale 1ns/1ps
// 110652011

// Full adder
module adder(A, B, cin, result, cout);

input A, B, cin;
output result, cout;

wire w1, w2, w3;

assign w1 = A ^ B;
assign w2 = A & B;

assign result = w1 ^ cin;
assign w3 = w1 & cin;

assign cout = w2 | w3;

endmodule