//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110652011
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;  // 0 for add, 1 for sub, 2 for function field, 3 for slt

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation

    always @(funct_i, ALUOp_i) begin
        case (ALUOp_i)

            0:       // add
                ALUCtrl_o <= 2;

            1:       // sub
                ALUCtrl_o <= 6;
            
            2: begin // R-Type
                case (funct_i)
                    32: ALUCtrl_o <= 2; // add
                    34: ALUCtrl_o <= 6; // sub
                    36: ALUCtrl_o <= 0; // and
                    37: ALUCtrl_o <= 1; // or
                    42: ALUCtrl_o <= 7; // slt
                    default: ALUCtrl_o = 0; // Should never meet
                endcase
            end

            3:       // stl
                ALUCtrl_o <= 7;
            
            default: // Should never meet
                ALUCtrl_o <= 0;
        
        endcase
    end

endmodule     