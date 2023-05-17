`timescale 1ns / 1ps
// 110652011
module Pipelined_CPU(
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
wire    [32-1:0]    IF_pc1, IF_pc2, IF_pc4; // pc, pc + 4.
wire    [32-1:0]    IF_ins;         // instruction

/**** ID stage ****/
wire     [32-1:0]       ID_pc2;
wire     [32-1:0]       ID_ins;
wire    [2-1:0]         ID_PCsrc;
wire    [2-1:0]         ID_MemtoReg;     	// MUX the data to register write.
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
wire    [32-1:0]        ID_JShifted;

/**** EX stage ****/
wire    [32-1:0]        EX_pc2, EX_pc3;
wire    [32-1:0]        EX_Extended;
wire    [32-1:0]        EX_BShifted;
wire    [32-1:0]        EX_JShifted;
wire    [2-1:0]         EX_PCsrc;
wire    [2-1:0]         EX_MemtoReg;
wire                    EX_RegWrite;
wire    [5-1:0]         EX_Write_addr;
wire    [32-1:0]        EX_ReadData1;
wire    [32-1:0]        EX_ReadData2;
wire    [4-1:0]         EX_ALUCtrl;
wire                    EX_ALUsrc;
wire    [32-1:0]        EX_src2;
wire                    EX_Mem_Read;
wire                    EX_Mem_Write;
wire    [32-1:0]        EX_ALU_result;
wire                    EX_ALU_zero;

/**** MEM stage ****/
wire    [2-1:0]         MEM_PCsrc;
wire    [32-1:0]        MEM_pc2;
wire    [32-1:0]        MEM_pc3;
wire    [32-1:0]        MEM_ALU_result;
wire    [2-1:0]         MEM_MemtoReg;
wire                    MEM_RegWrite;
wire    [5-1:0]         MEM_Write_addr;
wire    [32-1:0]        MEM_ReadData1;
wire    [32-1:0]        MEM_Read_Data2;
wire    [32-1:0]        MEM_Mem_Data;
wire                    MEM_Mem_Read;
wire                    MEM_Mem_Write;
wire    [32-1:0]        MEM_Jump_addr;
wire    [32-1:0]        MEM_BShifted;


/**** WB stage ****/
wire    [2-1:0]         WB_MemtoReg;
wire                    WB_RegWrite;
wire    [5-1:0]         WB_Write_addr;
wire    [32-1:0]        WB_pc2;
wire    [32-1:0]        WB_Mem_Data;
wire    [32-1:0]        WB_ALU_result;
wire    [32-1:0]        WB_Reg_write_data;


/*==================================================================*/
/*                              design                              */
/*==================================================================*/

//Instantiate the components in IF stage

MUX_4to1 #(.size(32)) Mux0( // Modify N, which is the total length of input/output
    .data0_i(ID_pc2),           // 
    .data1_i(MEM_Jump_addr),    // jump
    .data2_i(MEM_pc3),          // beq
    .data3_i(MEM_ReadData1),    // jr
    .select_i(MEM_PCsrc),
    .data_o(IF_pc4)
);

ProgramCounter PC(
    .clk_i(clk_i),
	.rst_i(rst_i),
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
	.PCsrc_o(ID_PCsrc),
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

Shift_Left_Two_32 JShifter(
    .data_i({6'd0, ID_ins[25:0]}),
    .data_o(ID_JShifted)
);

Pipe_Reg #(.size(179)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({
        ID_pc2,
        ID_PCsrc,
        ID_MemtoReg,
        ID_ALUCtrl,
        ID_ALUsrc,
        ID_PCsrc,
        ID_Extended,
        ID_Mem_Read,
        ID_Mem_Write,
        ID_RegWrite,
        ID_Write_addr,
        ID_pc2[31:28],
        ID_JShifted[27:0],
        ID_ReadData1,
        ID_ReadData2
    }),
    .data_o({
        EX_pc2,         // 32
        EX_PCsrc,       // 2
        EX_MemtoReg,    // 2
        EX_ALUCtrl,     // 4
        EX_ALUsrc,      // 1
        EX_PCsrc,       // 2
        EX_Extended,   // 32
        EX_Mem_Read,    // 1
        EX_Mem_Write,   // 1
        EX_RegWrite,    // 1
        EX_Write_addr,  // 5
        EX_JShifted,    // 32
        EX_ReadData1,   // 32
        EX_ReadData2    // 32
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

MUX_2to1 #(.size(32)) MuxALUsrc(
    .data0_i(EX_ReadData2),
    .data1_i(EX_Extended),
    .select_i(EX_ALUsrc),
    .data_o(EX_src2)
);

ALU ALU(
    .src1_i(EX_ReadData1),
	.src2_i(EX_src2),
	.ctrl_i(EX_ALUCtrl),
	.result_o(EX_ALU_result),
	.zero_o(EX_ALU_zero)
);

Pipe_Reg #(.size(236)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({   // 173
        EX_PCsrc[1],    // 1
        (EX_PCsrc[0] & EX_ALU_zero | EX_PCsrc[1] & EX_PCsrc[0]),  // 1
        EX_pc2,         // 32
        EX_pc3,         // 32
        EX_ALU_result,  // 32
        EX_MemtoReg,    // 2
        EX_RegWrite,    // 1
        EX_Write_addr,  // 5
        EX_ReadData1,   // 32
        EX_ReadData2,  // 32
        EX_Mem_Read,    // 1
        EX_Mem_Write,   // 1
        EX_JShifted,    // 32
        EX_BShifted
    }),
    .data_o({   // 204
        MEM_PCsrc,      // 2
        MEM_pc2,        // 32
        MEM_pc3,        // 32
        MEM_ALU_result, // 32
        MEM_MemtoReg,   // 2
        MEM_RegWrite,   // 1
        MEM_Write_addr, // 5
        MEM_ReadData1,  // 32
        MEM_Read_Data2, // 32
        MEM_Mem_Read,   // 1
        MEM_Mem_Write,  // 1
        MEM_Jump_addr,  // 32
        MEM_BShifted    // 32
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

Pipe_Reg #(.size(104)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({
        MEM_pc2,
        MEM_MemtoReg,
        MEM_RegWrite,
        MEM_Write_addr,
        MEM_Mem_Data,
        MEM_ALU_result
    }),
    .data_o({
        WB_pc2,         // 32
        WB_MemtoReg,    // 2
        WB_RegWrite,    // 1
        WB_Write_addr,  // 5
        WB_Mem_Data,    // 21
        WB_ALU_result   // 32
    })
);


//Instantiate the components in WB stage

MUX_4to1 #(.size(32)) Mux3(
    .data0_i(WB_ALU_result),
    .data1_i(WB_Mem_Data),
    .data2_i(WB_pc2),
    // .data3_i(),
    .select_i(WB_MemtoReg),
    .data_o(WB_Reg_write_data)
);


endmodule