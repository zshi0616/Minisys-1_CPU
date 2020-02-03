`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Idecode32(read_data_1,read_data_2,Instruction,read_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,
                 opcplus4,read_register_1_address);
	input			reset;
    input			clock;
    output	[31:0]	read_data_1;	// ����ĵ�һ������
    output	[31:0]	read_data_2;	// ����ĵڶ�������
    input	[31:0]	Instruction;	// ȡָ��Ԫ����ָ��
    input	[31:0]	read_data;		// ��DATA RAM or I/O portȡ��������
    input	[31:0]	ALU_result;		// ��ִ�е�Ԫ��������Ľ������Ҫ��չ��������32λ
    input			Jal;			// ���Կ��Ƶ�Ԫ��˵����JALָ�� 
    input			RegWrite;		// ���Կ��Ƶ�Ԫ
    input			MemtoReg;		// ���Կ��Ƶ�Ԫ
    input			RegDst;			// ���Կ��Ƶ�Ԫ
    output	[31:0]	Sign_extend;	// ���뵥Ԫ�������չ���32λ������
    input	[31:0]	opcplus4;		// ����ȡָ��Ԫ��JAL����
                
	output[4:0] read_register_1_address;
	reg[31:0] register[0:31];			   //�Ĵ����鹲32��32λ�Ĵ���
    
    wire[31:0] read_data_1;
    wire[31:0] read_data_2;
    reg[4:0] write_register_address;
    reg[31:0] write_data;
    wire[4:0] read_register_2_address;
    wire[4:0] write_register_address_1;
    wire[4:0] write_register_address_0;
    wire[15:0] Instruction_immediate_value;
    wire[5:0] opcode;
	
	assign opcode = Instruction[31:26];	//OP
    assign read_register_1_address = Instruction[25:21]; //rs 
    assign read_register_2_address = Instruction[20:16]; //rt 
    assign write_register_address_1 = Instruction[15:11]; // rd(r-form)
    assign write_register_address_0 = Instruction[20:16]; //rt(i-form)
    assign Instruction_immediate_value = Instruction[15:0]; //data,rladr(i-form)
	
    wire sign;
	assign sign = Instruction_immediate_value[15];
	assign Sign_extend[31:16] = (sign==1'b1)?16'hffff:16'h0000;
    assign Sign_extend[15:0] = Instruction_immediate_value[15:0]; 
    
    assign read_data_1 = register[read_register_1_address];
    assign read_data_2 = register[read_register_2_address];
    
    always @* begin  //�������ָ����ָͬ���µ�Ŀ��Ĵ���
		if (Jal)
			write_register_address = 5'd31;
		else if (RegDst)
			write_register_address = write_register_address_1;
		else
			write_register_address = write_register_address_0;
    end
    
    always @* begin  //������̻�������ʵ�ֽṹͼ�����µĶ�·ѡ����,׼��Ҫд������
		if (Jal)
			write_data = opcplus4;
		else if (MemtoReg)
			write_data = read_data;
		else
			write_data = ALU_result;
    end
    
    integer i;
    always @(posedge clock) begin       // ������дĿ��Ĵ���
        if(~reset) begin              // ��ʼ���Ĵ�����
            for(i=0;i<32;i=i+1) register[i] <= i;
        end else if(RegWrite==1) begin  // ע��Ĵ���0�����0
			register[write_register_address] <= write_data;
			register[0] <= 0;
        end
    end
endmodule
