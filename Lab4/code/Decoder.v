// 110652011
module Decoder(
    instr_i,
	PCsrc_o,
	MemtoReg_o,
	Read1_o,
	Read2_o,
	RegWrite_o,
	Write_addr_o,
	ALUCtrl_o,
	ALUsrc_o,
	Mem_Read_o,
	Mem_Write_o
	);
     
//I/O ports
input	[32-1:0]	instr_i;

output	[2-1:0]		PCsrc_o;
output	[2-1:0]		MemtoReg_o;     	// MUX the data to register write.
output	[5-1:0]		Read1_o, Read2_o;	// Read register
output	       		RegWrite_o;
output	[5-1:0]		Write_addr_o;
output	[4-1:0]		ALUCtrl_o;
output	       		ALUsrc_o;
output	       		Mem_Read_o;
output	       		Mem_Write_o;
 
//Internal Signals
reg		[2-1:0]		PCsrc_o;
reg		[2-1:0]		MemtoReg_o;     	// MUX the data to register write.
reg		[5-1:0]		Read1_o, Read2_o; 	// Read register
reg		       		RegWrite_o;
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
					PCsrc_o    		<= 3;				// PCsrc -> jr
					MemtoReg_o		<= 0;
					Read1_o			<= instr_i[25:21];	// Read register[31]
					Read2_o			<= 0;
					RegWrite_o 		<= 0;
					Write_addr_o	<= 0;
					ALUCtrl_o		<= 0;
					ALUsrc_o		<= 0;
					Mem_Read_o		<= 0;
					Mem_Write_o		<= 0;
				end
				else begin
					PCsrc_o    		<= 0;
					MemtoReg_o		<= 0;				// ALU_result
					Read1_o			<= instr_i[25:21];
					Read2_o			<= instr_i[20:16];
					RegWrite_o 		<= 1;
					Write_addr_o	<= instr_i[15:11];
					ALUsrc_o		<= 0;
					Mem_Read_o		<= 0;
					Mem_Write_o		<= 0;

					case (instr_i[5:0])
						24:	ALUCtrl_o <= 13;	// mult
						32: ALUCtrl_o <= 2;     // add
						34: ALUCtrl_o <= 6;     // sub
						36: ALUCtrl_o <= 0;     // and
						37: ALUCtrl_o <= 1;     // or
						38: ALUCtrl_o <= 14;	// xor
						42: ALUCtrl_o <= 7;     // slt
						default: ALUCtrl_o = 0; // 
					endcase
				end
			end

			2: begin 			 	// Jump
				PCsrc_o    		<= 2;
				MemtoReg_o		<= 0;
				Read1_o			<= 0;
				Read2_o			<= 0;
				RegWrite_o 		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 0;
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			3: begin			 	// jal -> write pc to Reg[31] and {pc[31:28], address<<2} to pc
				PCsrc_o    		<= 2;
				MemtoReg_o		<= 2;	// pc + 4
				Read1_o			<= 0;
				Read2_o			<= 0;
				RegWrite_o 		<= 1;
				Write_addr_o	<= 31;
				ALUCtrl_o		<= 0;
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			4: begin 			 	// beq
				PCsrc_o    		<= 1;
				MemtoReg_o		<= 0;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= instr_i[20:16];
				RegWrite_o 		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 6;	// sub
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			8: begin 			 	// addi
				PCsrc_o    		<= 0;
				MemtoReg_o		<= 0;	// 
				Read1_o			<= instr_i[25:21];
				Read2_o			<= 0;
				RegWrite_o 		<= 1;
				Write_addr_o	<= instr_i[20:16];
				ALUCtrl_o		<= 2;
				ALUsrc_o		<= 1;	// instruction
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			10: begin			 	// slti
				PCsrc_o    		<= 0;
				MemtoReg_o		<= 0;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= 0;
				RegWrite_o 		<= 1;
				Write_addr_o	<= instr_i[20:16];
				ALUCtrl_o		<= 7;
				ALUsrc_o		<= 1;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end

			35: begin			 	// lw
				PCsrc_o    		<= 0;
				MemtoReg_o		<= 1;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= 0;
				RegWrite_o 		<= 1;
				Write_addr_o	<= instr_i[20:16];
				ALUCtrl_o		<= 2;
				ALUsrc_o		<= 1;
				Mem_Read_o		<= 1;
				Mem_Write_o		<= 0;
			end

			43: begin			 	// sw
				PCsrc_o    		<= 0;
				MemtoReg_o		<= 1;
				Read1_o			<= instr_i[25:21];
				Read2_o			<= instr_i[20:16];
				RegWrite_o 		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 2;	// add
				ALUsrc_o		<= 1;	// instruction
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 1;
			end

			default: begin
				PCsrc_o    		<= 0;
				MemtoReg_o		<= 0;
				Read1_o			<= 0;
				Read2_o			<= 0;
				RegWrite_o 		<= 0;
				Write_addr_o	<= 0;
				ALUCtrl_o		<= 0;
				ALUsrc_o		<= 0;
				Mem_Read_o		<= 0;
				Mem_Write_o		<= 0;
			end
		endcase
	end

endmodule
