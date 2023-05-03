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
wire              Branch;
wire              MemtoReg;
wire              Branch_type;
wire              Jump;
wire              Mem_Read;
wire              Mem_Write;
wire              ALUop;
wire              ALUsrc;
wire              Reg_Write;
wire              Reg_Dst;

// Register
wire    [ 6-1:0]  Write_Reg;
wire    [32-1:0]  Read_data1;
wire    [32-1:0]  Read_data2;
wire    [32-1:0]  Write_Data;

// ALU
wire    [32-1:0]  src2;
wire    [32-1:0]  ALU_result;
wire              ALU_zero;


// Greate componentes--------------------------------------------------------------------------------
ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc4),
	.pc_out_o(pc1)
	);

Adder Adder1(           // pc + 4
        .src1_i(pc1),
	.src2_i(4'd4),
	.sum_o(pc2)
	);

Instr_Memory IM(
        .pc_addr_i(pc1),
	.instr_o(ins)
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(ins[20:16]),
        .data1_i(ins[15:11]),
        .select_i(Reg_Dst),
        .data_o(Write_Reg)
        );	

Reg_File Registers(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(ins[25:21]),
        .RTaddr_i(ins[20:16]),
        .RDaddr_i(Write_Reg),
        .RDdata_i(Write_Data),
        .RegWrite_i(Reg_Write),
        .RSdata_o(Read_data1),
        .RTdata_o(Read_data2)
        );

Decoder Decoder(
        .instr_op_i(),
	.RegWrite_o(),
	.ALU_op_o(),
	.ALUSrc_o(),
	.RegDst_o(),
	.Branch_o(),
        .Jump_o(Jump)
	);

ALU_Ctrl AC(
        .funct_i(),
        .ALUOp_i(),
        .ALUCtrl_o() 
        );

Sign_Extend SE(
        .data_i(),
        .data_o()
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	

ALU ALU(
        .src1_i(),
	.src2_i(),
	.ctrl_i(),
	.result_o(),
	.zero_o()
	);

Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(),
	.data_i(),
	.MemRead_i(),
	.MemWrite_i(),
	.data_o()
	);

Adder Adder2(
        .src1_i(),
	.src2_i(),
	.sum_o()
	);

Shift_Left_Two_32 Shifter(
        .data_i(),
        .data_o()
        ); 		

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	

endmodule
		  


