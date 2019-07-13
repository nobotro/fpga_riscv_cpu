


module riscv_cpu(input clk,
input reset,
output reg[3:0] ledss

);

 
 
reg  socorcpu=0;//true is soc

reg[31:0] socdata;
reg[31:0] socaddress=0;
reg socload=0;

reg[31:0] romline;

reg[31:0] registers[0:31];//cpu registers


reg [31:0] pc=0;//program counter
//
reg [6:0] opcode;
//reg [5] rs1;
//reg [5] rd;


 
reg[11:0] imm;   //reg for save imediate(12bit) value
reg[2:0] func3;  //reg to save func3 value,max 3 bit

reg[4:0] rd;
reg[4:0] rs1;
reg[4:0] rs2;
reg[7:0] tmpof8;
reg[15:0] tmpof16;
reg[19:0] imm20;

 
wire[31:0] address;
 

wire[31:0] datawrite;
wire wren;

reg[31:0] datre;
reg[31:0] datwr;
reg wr_enable;
reg store=0;
reg load=0;
 reg[31:0] storeloadaddr;

reg[31:0] memmapioaddress;

wire[31:0] dataread;
 ramm ram(.address(address),
			.clock(clk),
			.data(datawrite),
			.wren(wren),
			.q(dataread)
			); //used 1 port ram ip core


integer i;
initial
begin

for(i=0;i<32;i=i+1)
registers[i]=0;


end
 
//if load or store is active when adress musb be load or store adress
//assign address= !(store | load) ?pc/4:storeloadaddr;
assign address=socload && socorcpu ? socaddress: (!(store | load) ?pc/4:storeloadaddr);

assign wren=wr_enable;
assign datawrite=datwr;
always@(posedge clk)
begin
socorcpu=~socorcpu;

end
 
always @(*)
begin
 
 //we have 2 global cycle , 1 for cpu and 1 for io
 
 
 //it is ios cycle
 //ios cycle has 2 stage set adress and load data from adress
 //
if(socorcpu)
begin

	//it is first stage,save prev cpu 
	if(!socload)
	begin

		 
		socaddress=40;
		socload=1;

	end
	else if (socload)
	begin
		ledss=dataread;
		socload=0;
	end

 
end


else begin

if(load)
	begin
	   
		case(load)
	 
				8:begin
						tmpof8=dataread&'hff;
						registers[rd]= {{24{tmpof8[7]}},tmpof8};
					end
				16:begin
						tmpof16=dataread&'hffff;
						registers[rd]= {{16{tmpof16[15]}},tmpof16};	
					end
				32:registers[rd]=dataread;
				81:registers[rd]=dataread&'hff;
				161:registers[rd]=dataread&'hffff;
					 
		endcase
		load=0;
	end

//if previous instruction was store data in memory
else if(store)
begin
store=0;
wr_enable=0;

end


else begin
//fetch opcode in current cycle if not store or load
romline=dataread;
opcode=romline[6:0];
func3=romline[14:12];//get func3 from opcode
 
case(opcode)
      
//Integer Register-Immediate Instructions
	7'b0010011:begin
	
		 rs1=romline[19:15];
		 rd=romline[11:7];
		 imm=romline[31:20];
		 
		 //{{20{imm[11]}},imm} is 32 bit signed extended value
		 case(func3)
			//ADDI
			3'b000:
				begin
				
				
				
			 
				 registers[rd]={{20{imm[11]}},imm}+registers[rs1];
				 pc=pc+4;
				end
				
			
			//SLTI
			3'b010:
			
				begin
			 
				 registers[rd]=$signed(registers[rs1])<$signed({{20{imm[11]}},imm});
				 pc=pc+4;

				
				end
			   

			//SLTIU
			3'b011:
			   begin
				 registers[rd]=registers[rs1]<{{20{imm[11]}},imm};
				 pc=pc+4;

				
				end
			
			
			//XORI
			3'b100:
			
		    	begin
				 registers[rd]=registers[rs1] ^ {{20{imm[11]}},imm} ;
				 pc=pc+4;

				
				end
			
			//ORI
			3'b110:
				
				begin
				 registers[rd]=registers[rs1] | {{20{imm[11]}},imm} ;
				 pc=pc+4;

				
				end
			
			//ANDI
			3'b111:
				begin
				 registers[rd]=registers[rs1] & {{20{imm[11]}},imm} ;
				 pc=pc+4;
				
				end
			
			//SLLI
			3'b001:
			
				begin
				 registers[rd]=registers[rs1] << imm[4:0] ;
				 pc=pc+4;

				
				end

			//SRLI,SRAI
			3'b101:
			   case(imm[11:7])
				 //SRLI
				 1'b0:
				   begin
					  registers[rd]=registers[rs1] >> imm[4:0] ;
					  pc=pc+4;
					 
					end
					
				//SRAI
				7'b01000:
					begin
					 
					  registers[rd]=registers[rs1] >>> imm[4:0] ;
					  pc=pc+4;
					 
					end
				 
				 
				 
				 
			   endcase
			
			endcase
			end
			
			
	//LUI
	7'b0110111:
	begin
	    
		 rd=romline[11:7];
		 imm=romline[31:12];
		 registers[rd]=imm<<12;
		 pc=pc+4;
		 
	end
	
	
	
	//AUIPC
	7'b0010111:
	begin
		rd=romline[11:7];
		imm=romline[31:12];
		registers[rd]=pc+(imm<<12);
		pc=pc+4;
	
	end
	
	
	
	
	
//Integer Register-Register Operations
	7'b0110011:begin
		 
		 rs1=romline[19:15];
		 rs2=romline[24:20];
		 rd=romline[11:7];
		 
		 case(func3)
		 	
			//ADD,SUB
			3'b000:
			  begin
			   case(romline[31:25])
				
				1'b0:
				  
				  begin
				  registers[rd]=registers[rs1] + registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  end
				7'b0100000:
				  begin
				   
				  registers[rd]=registers[rs1] - registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  
				  end
				
           			  
			  endcase
			  end
			
			//SLL
			3'b001:
			    begin
				   
				  registers[rd]=registers[rs1]<< registers[rs2]  ;
				  pc=pc+4;
				  
			  
				 end
			
			//SLT
			3'b010:
			     begin
				   
				  registers[rd]=$signed(registers[rs1]) < $signed(registers[rs2]);
				  pc=pc+4;
				  
				  
				  
				  end
			
			
			//SLTU
			3'b011:
		
				 begin
				   
				  registers[rd]=registers[rs1] < registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  
				  end
			//XOR
			3'b100:
			
				 begin
				   
				  registers[rd]=registers[rs1] ^ registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  
				  end
			
			//SRL,SRA 
			3'b101:
		
				case(romline[31:25])
				
				
				//SRL
				1'b0:
				  
				  begin
				  registers[rd]=registers[rs1] >> registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  end
				  
				//SRA
				7'b0100000:
				  begin
				   
				  registers[rd]=registers[rs1] >>> registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  
				  end
				
           			  
			  endcase
			
			//OR
			3'b110:
			
			 begin
				   
				  registers[rd]=registers[rs1] | registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  
				  end
			
			//AND
			3'b111:
			   begin
				   
				  registers[rd]=registers[rs1] & registers[rs2]  ;
				  pc=pc+4;
				  
				  
				  
				  end
			
					
		
		
		endcase
		end
		

	
//Unconditional Jumps

   //JAL
	7'b1101111:
	   begin
		
		//uj imm
		imm20={romline[31],romline[19:12],romline[20],romline[30:21]};
		rd=romline[11:7];
		registers[rd]=pc+4;
		$display("%b",({{11{imm20[19]}},imm20,1'b0}));
		pc=pc+({{11{imm20[19]}},imm20,1'b0});
				  
		
		end
	  
	
	
	
	//JALR
	7'b1100111:
	
		begin
		
		 rs1=romline[19:15];
		 rd=romline[11:7];
		 imm=romline[31:20];
		 registers[rd]=pc+4;
		 pc=($signed(registers[rs1])+$signed({{20{imm[11]}},imm})) & 'hfffffffe;
		
		
		end
	
	

		 
//Load Instructions
   
	7'b0000011:begin
		 rs1=romline[19:15];
		 rd=romline[11:7];
		 imm=romline[31:20];
		 storeloadaddr={{{20{imm[11]}}},imm}+registers[rs1];
		 pc=pc+4;
	    case(func3)
			 //LB
			 3'b000:load=8;
			 //LH		 
			 3'b001:load=16;
			 //LW
			 3'b010:load=32;
			 //LBU
			 3'b100:load=81;
			 //LHU
			 3'b101:load=161;		  	 
		 endcase
	    end
		 
		 
//Store Instructions
   7'b0100011:begin
	    
		 rs1=romline[19:15];
		 rs2=romline[24:20];
		 imm={romline[31:25],romline[11:7]};
		 storeloadaddr={{{20{imm[11]}}},imm}+registers[rs1];
		 pc=pc+4;
		 wr_enable=1;
		 store=1;
	   case(func3)
		 //SB
		 3'b000:datwr=registers[rs2]&'hff;
		 //SH
		 3'b001:datwr=registers[rs2]&'hffff;
		 //SW
		 3'b010:datwr=registers[rs2];
		
		endcase
		end
   
	
//Conditional Branches

   
	7'b1100011:begin
	    rs1=romline[19:15];
		 rs2=romline[24:20];
		 imm={romline[31],romline[7],romline[30:25],romline[11:8]};
	    case(func3)
		 
		 //BEQ
		 3'b000:
			 if(registers[rs1]==registers[rs2])
			 begin
				pc=pc+{{19{imm[11]}},imm,1'b0};
			 
			 end
			
		 
		 //BNE
		 3'b001:
		 if(registers[rs1]!=registers[rs2])
		 begin
			pc=pc+{{19{imm[11]}},imm,1'b0};
		 
		 end
		 
		 //BLT
		 3'b100:
		 if($signed(registers[rs1])<$signed(registers[rs2]))
		 begin
			pc=pc+{{19{imm[11]}},imm,1'b0};
		 
		 end
		 
		 //BGE
		 3'b101:
		 if($signed(registers[rs1])>=$signed(registers[rs2]))
		 begin
			pc=pc+{{19{imm[11]}},imm,1'b0};
		 
		 end
		 
		 //BLTU
		 3'b110:
		 if(registers[rs1]<registers[rs2])
		 begin
			pc=pc+{{19{imm[11]}},imm,1'b0};
		 
		 end
		 
		 //BGEU
		 3'b111:
		 if(registers[rs1]>=registers[rs2])
		 begin
			pc=pc+{{19{imm[11]}},imm,1'b0};
		 
		 end
		 
		 
		 
		 endcase
		 
		 end 
		 



endcase




end

end
end
endmodule


