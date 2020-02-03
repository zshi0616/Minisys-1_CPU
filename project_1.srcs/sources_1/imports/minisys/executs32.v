`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Executs32(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
                 Shamt,ALUSrc,I_format,Zero,Sftmd,ALU_Result,Add_Result,PC_plus_4
                 );
    input	[31:0]	Read_data_1;		// �����뵥Ԫ��Read_data_1����
    input	[31:0]	Read_data_2;		// �����뵥Ԫ��Read_data_2����
    input	[31:0]	Sign_extend;		// �����뵥Ԫ������չ���������
    input	[5:0]	Function_opcode;	// ȡָ��Ԫ����r-����ָ�����;r-form instructions[5:0]
    input	[5:0]	Exe_opcode;			// ȡָ��Ԫ���Ĳ�����
    input	[1:0]	ALUOp;				// ���Կ��Ƶ�Ԫ������ָ����Ʊ���
    input	[4:0]	Shamt;				// ����ȡָ��Ԫ��instruction[10:6]��ָ����λ����
    input			Sftmd;				// ���Կ��Ƶ�Ԫ�ģ���������λָ��
    input			ALUSrc;				// ���Կ��Ƶ�Ԫ�������ڶ�������������������beq��bne���⣩
    input			I_format;			// ���Կ��Ƶ�Ԫ�������ǳ�beq; bne; LW; SW֮���I-����ָ��
    output			Zero;				// Ϊ1��������ֵΪ0 
    output	[31:0]	ALU_Result;			// ��������ݽ��
	output	[31:0]	Add_Result;			// ����ĵ�ַ���        
    input	[31:0]	PC_plus_4;			// ����ȡָ��Ԫ��PC+4
    
    reg[31:0] ALU_Result;
    wire[31:0] Ainput,Binput;
    reg[31:0] Cinput,Dinput;
    reg[31:0] Einput,Finput;
    reg[31:0] Ginput,Hinput;
    reg[31:0] Sinput;
    reg[31:0] ALU_output_mux;
    wire[32:0] Branch_Add;
    wire[2:0] ALU_ctl;
    wire[5:0] Exe_code;
    wire[2:0] Sftm;
    wire Sftmd;
    reg s;
    
    assign Sftm = Function_opcode[2:0];   // ʵ�����õ�ֻ�е���λ(��λָ�
    assign Exe_code = (I_format==0) ? Function_opcode : {3'b000,Exe_opcode[2:0]};
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0]; //R/LW,SW  sft  else��ʱ��LW��SW
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];      //24H AND 
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];

always @* begin  // 6����λָ��
       if(Sftmd)
        case(Sftm[2:0])
            3'b000:Sinput = Binput << Shamt;   //Sll rd,rt,Shamt  00000
            3'b010:Sinput = Binput >> Shamt;   //Srl rd,rt,Shamt  00010
            3'b100:Sinput = Binput << Ainput;  //Sllv rd,rt,rs 000100
            3'b110:Sinput = Binput >> Ainput;  //Srlv rd,rt,rs 000110
            //3'b011:Sinput = Binput >>> Shamt;  //Sra rd,rt,Shamt 00011
            //3'b111:Sinput = Binput >>> Ainput; //Srav rd,rt,rs 00111
            3'b011:Sinput = ({32{Binput[31]}} << ~Shamt) | (Binput >> Shamt);
            3'b111:Sinput = ({32{Binput[31]}} << ~Ainput) | (Binput >> Ainput);
            default:Sinput = Binput;
        endcase
       else Sinput = Binput;
    end
 
    always @* begin
        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) //slti(sub)  ��������SLT�������
            ALU_Result = (Ainput < Binput)? 1'b1: 1'b0;
        else if((ALU_ctl==3'b101) && (I_format==1)) ALU_Result[31:0] = (Binput<<16)&32'hFFFF0000;
        else if(Sftmd==1) ALU_Result = Sinput; 
        else  ALU_Result = ALU_output_mux[31:0]; //otherwise
    end
 
    assign Branch_Add = PC_plus_4[31:2] + Sign_extend[31:0]<<2;
    assign Add_Result = Branch_Add[31:0];   //�������һ��PCֵ�Ѿ����˳�4�������Բ�������16λ
    assign Zero = (ALU_output_mux[31:0]== 32'h00000000) ? 1'b1 : 1'b0;
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000:ALU_output_mux = Ainput & Binput;
            3'b001:ALU_output_mux = Ainput | Binput;
            3'b010:ALU_output_mux = Ainput + Binput;
            3'b011:ALU_output_mux = Ainput + Binput;
            3'b100:ALU_output_mux = Ainput ^ Binput;
            3'b101:ALU_output_mux = ~(Ainput|Binput);
            3'b110:ALU_output_mux = Ainput - Binput;
            3'b111:ALU_output_mux = Ainput - Binput;
            default:ALU_output_mux = 32'h00000000;
        endcase
    end
endmodule
