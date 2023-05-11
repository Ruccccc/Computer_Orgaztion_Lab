//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_i,
	Jump_type_o,
	MemtoReg_o,
	Read1_o,
	Read2_o,
	Reg_Write_o,
	Write_addr_o,
	ALUCtrl_o,
	ALUsrc_o,
	Mem_Read_o,
	Mem_Write_o
	);
     
//I/O ports
input	[32-1:0]	instr_i;

output	[2-1:0]		Jump_type_o;
output	[2-1:0]		MemtoReg_o;     	// MUX the data to register write.
output	[5-1:0]		Read1_o, Read2_o;	// Read register
output	       		Reg_Write_o;
output	[5-1:0]		Write_addr_o;
output	[4-1:0]		ALUCtrl_o;
output	       		ALUsrc_o;
output	       		Mem_Read_o;
output	       		Mem_Write_o;
 
//Internal Signals
reg		[2-1:0]		Jump_type_o;
reg		[2-1:0]		MemtoReg_o;     	// MUX the data to register write.
reg		[5-1:0]		Read1_o, Read2_o; 	// Read register
reg		       		Reg_Write_o;
reg		[5-1:0]		Write_addr_o;
reg		[4-1:0]		ALUCtrl_o;
reg		       		ALUsrc_o;
reg		       		Mem_Read_o;
reg		       		Mem_Write_o;

//Parameter


//Main function

	always @(instr_i) begin
		case (instr_i[31:26])

			0: begin			 // R-type
				if (instr_i[5:0] === 8) begin			// jr
					Jump_type_o		<= 3;				// Jump_type -> jr
					MemtoReg_o		<= 0;
					Read1_o			<= instr_i[25:21];	// Read register[31]
					Read2_o			<= 0;
					Reg_Write_o		<= 0;
					Write_addr_o	<= 0;
					ALUCtrl_o		<= 0;
					ALUsrc_o		<= 0;
					Mem_Read_o		<= 0;
					Mem_Write_o		<= 0;
				end
				else begin
					Jump_type_o		<= 0;
					MemtoReg_o		<= 0;				// ALU_result
					Read1_o			<= instr_i[25:21];
					Read2_o			<= instr_i[20:16];
					Reg_Write_o		<= 1;
					Write_addr_o	<= instr_i[15:11];
					ALUsrc_o		<= 0;
					Mem_Read_o		<= 0;
					Mem_Write_o		<= 0;

					case (instr_i[5:0])
						32: ALUCtrl_o <= 2;     // add
						34: ALUCtrl_o <= 6;     // sub
						36: ALUCtrl_o <= 0;     // and
						37: ALUCtrl_o <= 1;     // or
						42: ALUCtrl_o <= 7;     // slt
						default: ALUCtrl_o = 0; // Should never meet
					endcase
				end
			end

			2: begin 			 	// Jump
				Jump_type_o		<= 2;
				MemtoReg_o		<= 0;
				Read1_o			<= 0;
				Read2_o			<= 0;
				Reg_Write_o		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 0;
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			3: begin			 	// jal -> write pc to Reg[31] and {pc[31:28], address<<2} to pc
				Jump_type_o		<= 2;
				MemtoReg_o		<= 2;	// pc + 4
				Read1_o			<= 0;
				Read2_o			<= 0;
				Reg_Write_o		<= 1;
				Write_addr_o	<= 31;
				ALUCtrl_o		<= 0;
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			4: begin 			 	// beq
				Jump_type_o		<= 1;
				MemtoReg_o		<= 0;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= instr_i[20:16];
				Reg_Write_o		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 6;	// sub
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			8: begin 			 	// addi
				Jump_type_o		<= 0;
				MemtoReg_o		<= 0;	// 
				Read1_o			<= instr_i[25:21];
				Read2_o			<= 0;
				Reg_Write_o		<= 1;
				Write_addr_o	<= instr_i[20:16];
				ALUCtrl_o		<= 2;
				ALUsrc_o		<= 1;	// instruction
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			10: begin			 	// slti
				Jump_type_o		<= 0;
				MemtoReg_o		<= 0;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= 0;
				Reg_Write_o		<= 1;
				Write_addr_o	<= instr_i[20:16];
				ALUCtrl_o		<= 7;
				ALUsrc_o		<= 1;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			35: begin			 	// lw
				Jump_type_o		<= 0;
				MemtoReg_o		<= 1;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= 0;
				Reg_Write_o		<= 1;
				Write_addr_o	<= instr_i[20:16];
				ALUCtrl_o		<= 2;
				ALUsrc_o		<= 1;
				Mem_Read_o		<= 1;
				Mem_Write_o		<= 0;
			end

			43: begin			 	// sw
				Jump_type_o		<= 0;
				MemtoReg_o		<= 1;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= instr_i[20:16];
				Reg_Write_o		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 2;	// add
				ALUsrc_o		<= 1;	// instruction
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 1;
			end

			default: begin
				Jump_type_o		<= 0;
				MemtoReg_o		<= 0;
				Read1_o			<= 0;
				Read2_o			<= 0;
				Reg_Write_o		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 0;
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end
		endcase
	end

endmodule
