`timescale 1ns / 1ps
// 110652011
module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk_i;
input rst_i;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

/**** IF stage ****/
wire    [32-1:0]        IF_pc1, IF_pc2, IF_pc4; // pc, pc + 4.
wire    [32-1:0]        IF_ins;         // instruction
wire                    IF_pcwrite;
wire                    B_Flush;

/**** ID stage ****/
wire                    ID_Flush;

wire    [32-1:0]        ID_pc2;
wire    [32-1:0]        ID_ins;

wire    [3-1:0]         ID_Branch;
wire                    ID_MemtoReg;     	// MUX the data to register write.
wire    [5-1:0]         ID_ReadAddr1; 	    // Read register
wire    [5-1:0]         ID_ReadAddr2;
wire    [4-1:0]	        ID_ALUCtrl;
wire	                ID_ALUsrc;
wire    [32-1:0]        ID_ReadData1;
wire    [32-1:0]        ID_ReadData2;
wire    [32-1:0]        ID_Extended;
wire	       	        ID_Mem_Read;
wire	       	        ID_Mem_Write;
wire	       	        ID_RegWrite;
wire	[5-1:0]	        ID_Write_addr;

/**** EX stage ****/
wire                    EX_Flush;
wire    [2-1:0]         EX_muxrs;
wire    [2-1:0]         EX_muxrt;


wire    [6-1:0]         EX_op;
wire    [32-1:0]        EX_pc2;
wire    [32-1:0]        EX_pc3;
wire    [5-1:0]         EX_ReadAddr1; 	    // Read register
wire    [5-1:0]         EX_ReadAddr2;
wire    [32-1:0]        EX_Extended;
wire    [32-1:0]        EX_BShifted;
// wire    [32-1:0]        EX_JShifted;
wire    [3-1:0]         EX_Branch;
wire                    EX_MemtoReg;
wire                    EX_RegWrite;
wire    [5-1:0]         EX_Write_addr;
wire    [32-1:0]        EX_ReadData1_1;
wire    [32-1:0]        EX_ReadData1_2;
wire    [32-1:0]        EX_ReadData2_1;
wire    [32-1:0]        EX_ReadData2_2;
wire    [32-1:0]        EX_ReadData2_3;
wire    [4-1:0]         EX_ALUCtrl;
wire                    EX_ALUsrc;
wire                    EX_Mem_Read;
wire                    EX_Mem_Write;

wire    [32-1:0]        EX_ALU_result;
wire                    EX_ALU_zero;
wire                    EX_ALU_pos;

/**** MEM stage ****/
wire    [6-1:0]         MEM_op;
wire    [3-1:0]         MEM_Branch;
wire    [32-1:0]        MEM_pc2;
wire    [32-1:0]        MEM_pc3;
wire    [32-1:0]        MEM_ALU_result;
wire                    MEM_ALU_zero;
wire                    MEM_ALU_pos;
wire                    MEM_MemtoReg;
wire                    MEM_RegWrite;
wire    [5-1:0]         MEM_Write_addr;
wire    [32-1:0]        MEM_ReadData1;
wire    [32-1:0]        MEM_Read_Data2;
wire                    MEM_Mem_Read;
wire                    MEM_Mem_Write;
wire    [32-1:0]        MEM_BShifted;

wire                    MEM_Branch_2;
wire    [32-1:0]        MEM_Mem_Data;

/**** WB stage ****/
wire    [6-1:0]         WB_op;
wire                    WB_MemtoReg;
wire                    WB_RegWrite;
wire    [5-1:0]         WB_Write_addr;
wire    [32-1:0]        WB_pc2;
wire    [32-1:0]        WB_Mem_Data;
wire    [32-1:0]        WB_ALU_result;
wire    [32-1:0]        WB_Reg_write_data;


/*==================================================================*/
/*                              design                              */
/*==================================================================*/

Hazard_Detection HD(
    .EX_op(EX_op),
    .Branch(MEM_Branch_2),
    .ID_rs(ID_ReadAddr1),
    .ID_rt(ID_ReadAddr2),
    .EX_rd(EX_Write_addr),
    // .MEM_rd(MEM_Write_addr),
    .ID_Flush(ID_Flush),
    .B_Flush(B_Flush),
    // .EX_Flush(EX_Flush),
    .PCWrite(IF_pcwrite)
);

Forwarding_Unit FU(
    .clk_i(clk_i),
    .MEM_RegWrite_i(MEM_RegWrite),
    .WB_RegWrite_i(WB_RegWrite),
    .EX_rs(EX_ReadAddr1),
    .EX_rt(EX_ReadAddr2),
    .EX_rd(EX_Write_addr),
    .MEM_rd(MEM_Write_addr),
    .WB_rd(WB_Write_addr),
    .muxrs(EX_muxrs),
    .muxrt(EX_muxrt)
);

//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux0(
    .data0_i(IF_pc2),           // nothing
    .data1_i(MEM_pc3),          // branch
    .select_i(MEM_Branch_2),
    .data_o(IF_pc4)
);

ProgramCounter PC(
    .clk_i(clk_i),
	.rst_i(rst_i),
    .pc_write(IF_pcwrite),
	.pc_in_i(IF_pc4),
	.pc_out_o(IF_pc1)
);

Instruction_Memory IM(
    .addr_i(IF_pc1),
    .instr_o(IF_ins)
);
			
Adder Add_pc(
    .src1_i(IF_pc1),
    .src2_i(32'd4),
    .sum_o(IF_pc2)
);
		
Pipe_Reg #(.size(64)) IF_ID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(B_Flush),
    .write(IF_pcwrite),
    .data_i({
        IF_pc2,
        IF_ins
    }),
    .data_o({
        ID_pc2,     // 32
        ID_ins      // 32
    })
);


//Instantiate the components in ID stage

Decoder Control(
    .instr_i(ID_ins),
	.Branch_o(ID_Branch),
	.MemtoReg_o(ID_MemtoReg),
	.Read1_o(ID_ReadAddr1),
	.Read2_o(ID_ReadAddr2),
	.RegWrite_o(ID_RegWrite),
	.Write_addr_o(ID_Write_addr),
	.ALUCtrl_o(ID_ALUCtrl),
	.ALUsrc_o(ID_ALUsrc),
	.Mem_Read_o(ID_Mem_Read),
	.Mem_Write_o(ID_Mem_Write)
);

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(ID_ReadAddr1),
    .RTaddr_i(ID_ReadAddr2),
    .RDaddr_i(WB_Write_addr),
    .RDdata_i(WB_Reg_write_data),
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(ID_ReadData1),
    .RTdata_o(ID_ReadData2)
);

Sign_Extend SE(
    .data_i(ID_ins[15:0]),
    .data_o(ID_Extended)
);

Pipe_Reg #(.size(161)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(B_Flush || ID_Flush),
    .write(1'b1),
    .data_i({
        ID_ins[31:26],      // 6
        ID_pc2,             // 32
        ID_Branch,          // 2
        ID_MemtoReg,        // 2
        ID_ALUCtrl,         // 2
        ID_ALUsrc,          // 4
        ID_Extended,        // 32
        ID_Mem_Read,        // 1
        ID_Mem_Write,       // 1
        ID_RegWrite,        // 1
        ID_Write_addr,      // 5
        ID_ReadData1,
        ID_ReadData2,
        ID_ReadAddr1,
        ID_ReadAddr2
    }),
    .data_o({
        EX_op,              // 6
        EX_pc2,             // 32
        EX_Branch,          // 2
        EX_MemtoReg,        // 2
        EX_ALUCtrl,         // 4
        EX_ALUsrc,          // 1
        EX_Extended,        // 32
        EX_Mem_Read,        // 1
        EX_Mem_Write,       // 1
        EX_RegWrite,        // 1
        EX_Write_addr,      // 5
        EX_ReadData1_1,     // 32
        EX_ReadData2_1,     // 32
        EX_ReadAddr1,
        EX_ReadAddr2
    })
);

//Instantiate the components in EX stage

Shift_Left_Two_32 BShifter(
    .data_i(EX_Extended),
    .data_o(EX_BShifted)
);

Adder Add_pc_branch(
    .src1_i(EX_pc2),
    .src2_i(EX_BShifted),
    .sum_o(EX_pc3)
);

MUX_4to1 #(.size(32)) MuxRs(
    .data0_i(EX_ReadData1_1),
    .data1_i(MEM_ALU_result),
    .data2_i(WB_Reg_write_data),
    .select_i(EX_muxrs),
    .data_o(EX_ReadData1_2)
);

MUX_4to1 #(.size(32)) MuxRt(
    .data0_i(EX_ReadData2_1),
    .data1_i(MEM_ALU_result),
    .data2_i(WB_Reg_write_data),
    .select_i(EX_muxrt),
    .data_o(EX_ReadData2_2)
);

MUX_2to1 #(.size(32)) MuxALUsrc(
    .data0_i(EX_ReadData2_2),
    .data1_i(EX_Extended),
    .select_i(EX_ALUsrc),
    .data_o(EX_ReadData2_3)
);

ALU ALU(
    .src1_i(EX_ReadData1_2),
	.src2_i(EX_ReadData2_3),
	.ctrl_i(EX_ALUCtrl),
	.result_o(EX_ALU_result),
	.zero_o(EX_ALU_zero),
    .pos_o(EX_ALU_pos)
);

Pipe_Reg #(.size(148)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(B_Flush),
    .write(1'b1),
    .data_i({
        EX_op,          // 6
        EX_Branch,      // 3
        EX_pc2,         // 32
        EX_pc3,         // 32
        EX_ALU_result,  // 32
        EX_ALU_zero,    // 1
        EX_ALU_pos,     // 1
        EX_MemtoReg,    // 1
        EX_RegWrite,    // 1
        EX_Write_addr,  // 5
        EX_ReadData2_2, // 32
        EX_Mem_Read,    // 1
        EX_Mem_Write    // 1
    }),
    .data_o({
        MEM_op,         // 6
        MEM_Branch,     // 3
        MEM_pc2,        // 32
        MEM_pc3,        // 32
        MEM_ALU_result, // 32
        MEM_ALU_zero,   // 1
        MEM_ALU_pos,    // 1
        MEM_MemtoReg,   // 1
        MEM_RegWrite,   // 1
        MEM_Write_addr, // 5
        MEM_Read_Data2, // 32
        MEM_Mem_Read,   // 1
        MEM_Mem_Write   // 1
    })
);

//Instantiate the components in MEM stage

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(MEM_ALU_result),
    .data_i(MEM_Read_Data2),
    .MemRead_i(MEM_Mem_Read),
    .MemWrite_i(MEM_Mem_Write),
    .data_o(MEM_Mem_Data)
);

MUX_8to1 #(.size(1)) MuxBranch(
    .data0_i(1'b0),
    .data1_i(MEM_ALU_zero),
    .data2_i((~MEM_ALU_zero)),
    .data3_i(MEM_ALU_pos),
    .data4_i((MEM_ALU_pos || MEM_ALU_zero)),
    .select_i(MEM_Branch),
    .data_o(MEM_Branch_2)
);

Pipe_Reg #(.size(109)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(B_Flush),
    .write(1'b1),
    .data_i({
        MEM_op,
        MEM_pc2,
        MEM_MemtoReg,
        MEM_RegWrite,
        MEM_Write_addr,
        MEM_Mem_Data,
        MEM_ALU_result
    }),
    .data_o({
        WB_op,          // 6
        WB_pc2,         // 32
        WB_MemtoReg,    // 1
        WB_RegWrite,    // 1
        WB_Write_addr,  // 5
        WB_Mem_Data,    // 21
        WB_ALU_result   // 32
    })
);


//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux3(
    .data0_i(WB_ALU_result),
    .data1_i(WB_Mem_Data),
    .select_i(WB_MemtoReg),
    .data_o(WB_Reg_write_data)
);


endmodule