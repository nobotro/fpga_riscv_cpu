


module riscv_cpu(input clk,
input reset,
output reg[3:0] ledss

);

 
 

wire[31:0] romline;

reg[31:0] registers[0:31];//cpu registers


reg [31:0] pc=0;//program counter
//
reg [6:0] opcode;
//reg [5] rs1;
//reg [5] rd;


 
wire[11:0] imm;  
wire[11:0] imms; 
wire[11:0] immc; 
wire[11:0] immlui;
wire[4:0] rd;
reg[4:0] rd_load=0;
wire[4:0] rs1;
wire[4:0] rs2;
wire[7:0] tmpof8;
wire[15:0] tmpof16;
wire[19:0] imm20;

 
wire[31:0] address;
 

 
reg[31:0] datwr=0;
reg wr_enable=0;
reg store=0;
reg[10:0] load=0;
 reg[31:0] storeloadaddr=0;

wire[2:0] func3;
wire[6:0] func7;


reg do_cond_branch=0;
integer i;
initial
begin

for(i=0;i<32;i=i+1)
registers[i]=0;


end






 ramm ram(.address(address),
			.clock(clk2),
			.data(datwr),
			.wren(wr_enable),
			.q(romline)
			); //
			

 
 
 
 assign rd=romline[11:7];
 assign tmpof8=romline&'hff;
 assign tmpof16=romline&'hffff;
 assign address=load || store ? storeloadaddr : pc>>>2;
 assign rs1=romline[19:15];
 assign rs2=romline[24:20];
 assign imms={romline[31:25],romline[11:7]};
 assign immc={romline[31],romline[7],romline[30:25],romline[11:8]};
 assign imm=romline[31:20];
 assign imm20={romline[31],romline[19:12],romline[20],romline[30:21]};
 assign immlui=romline[31:12];
assign func3=romline[14:12];
assign func7=romline[31:25];



reg clk2=0;
always @(negedge clk)
begin
clk2<=!clk2;


end
always @(negedge clk2)
begin
 
 
 
if(load)
	begin
	   
		case(load)
	 
				8:registers[rd_load]<= {{24{tmpof8[7]}},tmpof8};
				16:registers[rd_load]<= {{16{tmpof16[15]}},tmpof16};	
				32:registers[rd_load]<=romline;
				81:registers[rd_load]<=romline&'hff;
				161:registers[rd_load]<=romline&'hffff;
				default:i<=0;
					 
		endcase
		load<=0;
		pc<=pc+4;
		 
	end

//if previous instruction was store data in memory
else if(store)
	begin
		store<=0;
		wr_enable<=0;
		 pc<=pc+4;

	end


else begin
//fetch opcode  if not store or load
 
 
case(romline[6:0])
      
   //Integer Register-Immediate Instructions
	7'b0010011:begin
			 case(func3)
					//ADDI
					3'b000:registers[rd]<={{20{imm[11]}},imm}+registers[rs1];
					//SLTI
			      3'b010:registers[rd]<=$signed(registers[rs1])<$signed({{20{imm[11]}},imm});
				   //SLTIU
					3'b011:registers[rd]<=registers[rs1]<{{20{imm[11]}},imm};
					//XORI
					3'b100:registers[rd]<=registers[rs1] ^ {{20{imm[11]}},imm} ;      		 
			      //ORI
					3'b110:registers[rd]<=registers[rs1] | {{20{imm[11]}},imm} ;
				   //ANDI
					3'b111:registers[rd]<=registers[rs1] & {{20{imm[11]}},imm} ;
					//SLLI
					3'b001:registers[rd]<=registers[rs1] << imm[4:0] ;
				   //SRLI,SRAI
					3'b101:
						case(imm[11:7])
							 //SRLI
							 7'b0000000:registers[rd]<=registers[rs1] >> imm[4:0] ;
						  	 //SRAI
							 7'b0001000:registers[rd]<=registers[rs1] >>> imm[4:0] ;
							 default:i<=0;
						endcase
			 default:i<=0;
			 endcase
			 pc<=pc+4;
		
		 end
	//LUI
	7'b0110111:begin
	  	   
		 registers[rd]<=immlui<<12;
		 pc<=pc+4;
		 
	end
	
	//AUIPC
	7'b0010111:begin
		 
		registers[rd]<=pc+(immlui<<12);
		pc<=pc+4;
	
	end
	
	//Integer Register-Register Operations
	7'b0110011:begin
	 
		 case(func3)
		 	
			//ADD,SUB
			3'b000:
				  case(func7)	
						7'b0000000:registers[rd]<=registers[rs1] + registers[rs2]  ;
						7'b0100000:registers[rd]<=registers[rs1] - registers[rs2]  ;	
	                default:i<=0;					
				  endcase
			
			//SLL
			3'b001:registers[rd]<=registers[rs1] << registers[rs2]  ;
		//SLT
			3'b010:registers[rd]<=$signed(registers[rs1]) < $signed(registers[rs2]);
			//SLTU
			3'b011:registers[rd]<=registers[rs1] < registers[rs2]  ;
			//XOR
			3'b100:registers[rd]<=registers[rs1] ^ registers[rs2]  ;
			//SRL,SRA 
			3'b101:
				 case(func7)
			
					//SRL
					7'b0000000:registers[rd]<=registers[rs1] >> registers[rs2]  ;
					//SRA
					7'b0100000:registers[rd]<=registers[rs1] >>> registers[rs2]  ;
				 default:i<=0;
			    endcase
//			
 	//OR
 		3'b110:registers[rd]<=registers[rs1] | registers[rs2]  ;
//			//AND
 		3'b111:registers[rd]<=registers[rs1] & registers[rs2]  ;
			default:i<=0;
		
		endcase
		
		 pc<=pc+4;
		end
		

	
	
	
	

   //JAL
	7'b1101111:begin
		
			registers[rd]<=pc+4;
			pc<=pc+({{11{imm20[19]}},imm20,1'b0});	  
			
		end
   //JALR
	7'b1100111:begin
		
		 registers[rd]<=pc+4;
		 pc<=($signed(registers[rs1])+$signed({{20{imm[11]}},imm})) & 'hfffffffe;	
		
		end
	  

	  
	  
   //Load Instructions   
	7'b0000011:begin
			 rd_load<=romline[11:7];
			 storeloadaddr<={{{20{imm[11]}}},imm}+registers[rs1];
			 case(func3)
				 //LB
				 3'b000:load<=8;
				 //LH		 
				 3'b001:load<=16;
				 //LW
				 3'b010:load<=32;
				 //LBU
				 3'b100:load<=81;
				 //LHU
				 3'b101:load<=161;		  	 
				 default:i<=0;
			 endcase
	    end
		 
		 
   //Store Instructions
   7'b0100011:begin
		 
			 storeloadaddr<={{{20{imms[11]}}},imms}+registers[rs1];
			 wr_enable<=1;
			 store<=1;
				case(func3)
				 //SB
				 3'b000:datwr<=registers[rs2]&'hff;
				 //SH
				 3'b001:datwr<=registers[rs2]&'hffff;
				 //SW
				 3'b010:datwr<=registers[rs2];
				default:i<=0;
				endcase
		end
   
	
	
  //Conditional Branches   
	7'b1100011:begin 
	    case(func3)
		 
		
	  //BGE
		 3'b101: 
					if($signed(registers[rs1])>=$signed(registers[rs2]))
						 pc<=pc+{{19{immc[11]}},immc,1'b0};
					else pc<=pc+4;
		//BEQ
		 3'b000:
					if(registers[rs1]==registers[rs2])
						pc<=pc+{{19{imm[11]}},imm,1'b0};
					else pc<=pc+4;
			 
		 //BNE
		 3'b001:
					if(registers[rs1]!=registers[rs2])
		             pc<=pc+{{19{imm[11]}},imm,1'b0};
				   else pc<=pc+4;
		 
		 
		 //BLT
		 3'b100:
					if($signed(registers[rs1])<$signed(registers[rs2]))
		             pc<=pc+{{19{imm[11]}},imm,1'b0};
					else pc<=pc+4;
		 
		 //BLTU
		 3'b110:
					if(registers[rs1]<registers[rs2])
		            pc<=pc+{{19{imm[11]}},imm,1'b0};
		         else pc<=pc+4;
		 
		 //BGEU
		 3'b111:
					if(registers[rs1]>=registers[rs2])
		            pc<=pc+{{19{imm[11]}},imm,1'b0};
					else pc<=pc+4;
		 
		 
		 
		 
		default:i<=0;
		 endcase
		 
		 
				 	 
		 end 
		 


default:i<=0;
endcase




end

end
 
endmodule
