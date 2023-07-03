// 110652011
module Forwarding_Unit(
    clk_i,
    MEM_RegWrite_i,
    WB_RegWrite_i,
    EX_rs,
    EX_rt,
    EX_rd,
    MEM_rd,
    WB_rd,
    muxrs,
    muxrt,
    );

input               clk_i;
input               MEM_RegWrite_i;
input               WB_RegWrite_i;
input   [5-1:0]     EX_rs;
input   [5-1:0]     EX_rt;
input   [5-1:0]     EX_rd;
input   [5-1:0]     MEM_rd;
input   [5-1:0]     WB_rd;
output  [2-1:0]     muxrs;
output  [2-1:0]     muxrt;

reg     [2-1:0]     muxrs;
reg     [2-1:0]     muxrt;
reg     [2-1:0]     flag;

always @(negedge clk_i) begin
    flag <= 0;
    muxrs <= 0;
    muxrt <= 0;
    if (MEM_RegWrite_i == 1 && (MEM_rd == EX_rs) && MEM_rd != 0) begin
        muxrs <= 1;
        flag  <= 1;
    end
    else if (WB_RegWrite_i == 1 && (WB_rd == EX_rs) && WB_rd != 0) begin
        muxrs <= 2;
        flag  <= 1;
    end
    if (MEM_RegWrite_i == 1 && (MEM_rd == EX_rt) && MEM_rd != 0) begin
        muxrt <= 1;
        flag  <= 2;
    end
    else if (WB_RegWrite_i == 1 && (WB_rd == EX_rt) && WB_rd != 0) begin
        muxrt <= 2;
        flag  <= 2;
    end
end

endmodule