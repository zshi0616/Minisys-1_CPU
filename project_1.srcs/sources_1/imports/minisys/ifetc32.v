`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Ifetc32(Instruction,PC_plus_4_out,Add_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jrn,Zero,clock,reset,opcplus4);
    output[31:0] Instruction;			// ���ָ��
    output[31:0] PC_plus_4_out;
    input[31:0]  Add_result;
    input[31:0]  Read_data_1;
    input        Branch;
    input        nBranch;
    input        Jmp;
    input        Jal;
    input        Jrn;
    input        Zero;
    input        clock,reset;
    output[31:0] opcplus4;
    
    wire[31:0]   PC_plus_4;
    reg[31:0]	  PC;
    reg[31:0]    next_PC; 
    wire[31:0]   Jpadr;
    reg[31:0]    opcplus4;
	
	assign PC_plus_4[31:2] = PC[31:2] + 1'b1;
	assign PC_plus_4[1:0] = PC[1:0]; 
	assign PC_plus_4_out = PC_plus_4;  
    
   //����64KB ROM��������ʵ��ֻ�� 64KB ROM
    prgrom instmem(
        .clka(clock),         // input wire clka
        .addra(PC[15:2]),     // input wire [13 : 0] addra
        .douta(Jpadr)         // output wire [31 : 0] douta
    );
    

    assign Instruction = Jpadr;              //  ȡ��ָ��

    always @* begin                          // beq $n ,$m if $n=$m branch   bne if $n /=$m branch jr
				
		
		if (Branch==1'b1 & Zero==1'b1)
			next_PC = Add_result;
		else if (nBranch==1'b1 & Zero==1'b0)
			next_PC = Add_result;
		else if (Jrn==1'b1)
			next_PC = Read_data_1;
		else
			next_PC = PC_plus_4;
    end
    
   always @(negedge clock) begin
		if (~reset)
		begin
			PC = 32'd0;
			opcplus4 = 32'd0;
		end
		else
		begin
			if (Jmp==1'b1)
			begin
				PC = Instruction[25:0]<<2;
			end
			else if (Jal==1'b1)
			begin
				opcplus4 = PC_plus_4;
				PC = Instruction[25:0]<<2;
			end
			else
			begin
				PC = next_PC;
			end
		end
   end
endmodule
