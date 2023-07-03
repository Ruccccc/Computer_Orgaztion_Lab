// 110652011
module Hazard_Detection(
    EX_op,
    Branch,
    ID_rs,
    ID_rt,
    EX_rd,
    ID_Flush,
    B_Flush,
    PCWrite
    );

input       [6-1:0]     EX_op;
input                   Branch;
input       [5-1:0]     ID_rs;
input       [5-1:0]     ID_rt;
input       [5-1:0]     EX_rs;
input       [5-1:0]     EX_rd;
output                  ID_Flush;
output                  B_Flush;
output                  PCWrite;

reg     ID_Flush;
reg     B_Flush;
reg     PCWrite;

always @(*) begin

    ID_Flush <= 0;
    B_Flush <= 0;
    PCWrite <= 1;

    if (Branch) begin
        B_Flush <= 1;
    end
    else if (EX_op == 6'd35) begin
        ID_Flush <= 1;
        PCWrite <= 0;
    end
    
end


endmodule