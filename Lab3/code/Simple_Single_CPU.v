//Subject:     CO project 3 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
	);
		
// I/O port
input         clk_i;
input         rst_i;

// Internal Signles--------------------------------------------------------------------------------

// program counter
wire    [32-1:0]  pc1, pc2, pc3, pc4;

// instruction
wire    [32-1:0]  ins;

// Decoder
wire    [2-1:0] Jump_type;      // 0 for not, 1 for branch, 2 for jump, 3 for jr.
wire    [2-1:0] MemtoReg;       // MUX the data to register write. // 0 for ALU_result, 1 for Memory. 2 for pc + 4
wire    [5-1:0] Read1, Read2;   // Read register.
wire            Reg_Write;      // Register Write or not.
wire    [5-1:0] Write_addr;     // Register write address.
wire    [4-1:0] ALUCtrl;        //
wire            ALUsrc;         // 0 for register, 1 for instruction.
wire            Mem_Read;       //
wire            Mem_Write;      //

// Register
wire    [32-1:0]  Read_data1;
wire    [32-1:0]  Read_data2;
wire    [32-1:0]  Write_Data;

// ALU
wire    [32-1:0]  src2;
wire    [32-1:0]  ALU_result;
wire              ALU_zero;

// Extend
wire    [32-1:0] Extended;

// Shift left
wire    [32-1:0] BShifted;      // For Branch
wire    [32-1:0] JShifted;      // For Jump

// DataMemroy
wire    [32-1:0] Mem_data;


// Greate componentes--------------------------------------------------------------------------------
ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc4),
	.pc_out_o(pc1)
	);

Adder Adder1(           // pc + 4
        .src1_i(pc1),
	.src2_i(32'd4),
	.sum_o(pc2)
	);

Instr_Memory IM(
        .pc_addr_i(pc1),
	.instr_o(ins)
	);

Reg_File Registers(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(Read1),
        .RTaddr_i(Read2),
        .RDaddr_i(Write_addr),
        .RDdata_i(Write_Data),
        .RegWrite_i(Reg_Write),
        .RSdata_o(Read_data1),
        .RTdata_o(Read_data2)
        );

Decoder Decoder(
        .instr_i(ins),
	.Jump_type_o(Jump_type),
	.MemtoReg_o(MemtoReg),
	.Read1_o(Read1),
	.Read2_o(Read2),
	.Reg_Write_o(Reg_Write),
        .Write_addr_o(Write_addr),
	.ALUCtrl_o(ALUCtrl),
	.ALUsrc_o(ALUsrc),
	.Mem_Read_o(Mem_Read),
	.Mem_Write_o(Mem_Write)
	);

Sign_Extend SE(
        .data_i(ins[15:0]),
        .data_o(Extended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(Read_data2),
        .data1_i(Extended),
        .select_i(ALUsrc),
        .data_o(src2)
        );

ALU ALU(
        .src1_i(Read_data1),
	.src2_i(src2),
	.ctrl_i(ALUCtrl),
	.result_o(ALU_result),
	.zero_o(ALU_zero)
	);

Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALU_result),
	.data_i(Read_data2),
	.MemRead_i(Mem_Read),
	.MemWrite_i(Mem_Write),
	.data_o(Mem_data)
	);

MUX_4to1 #(.size(32)) Mux_WriteData(
        .data0_i(ALU_result),   // other
        .data1_i(Mem_data),     // lw
        .data2_i(pc2),          // jar
        .select_i(MemtoReg),
        .data_o(Write_Data)
        );

Shift_Left_Two_32 Shifter1( // beq
        .data_i(Extended),
        .data_o(BShifted)
        );

Shift_Left_Two_32 Shifter2( // jump
        .data_i({6'd0, ins[25:0]}),
        .data_o(JShifted)
        );

Adder Adder2(
        .src1_i(pc2),
	.src2_i(BShifted),
	.sum_o(pc3)
	);

MUX_4to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc2),                                  //
        .data1_i(pc3),                                  // Branch
        .data2_i({pc2[31:28], JShifted[27:0]}),         // Jump
        .data3_i(Read_data1),                           // Jr
        .select_i({Jump_type[1], Jump_type[0] & ALU_zero | Jump_type[1] & Jump_type[0]}),
        .data_o(pc4)
        );

endmodule