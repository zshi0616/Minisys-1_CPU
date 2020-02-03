`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module switchs(switclk,switrst,switchread,switchaddrcs,switchrdata,switch_i);
    input switclk,switrst;
    input switchaddrcs,switchread;
    output [15:0] switchrdata;
    //���뿪������
    input [15:0] switch_i;

    reg [15:0] switchrdata;
    always@(negedge switclk or posedge switrst) begin
		if (~switrst)
		begin
			switchrdata <= 16'd0;
		end
		else
		begin
			if (switchaddrcs == 1'b1)
			begin
				if (switchread==1'b1)
					switchrdata <= switch_i;
				else
					switchrdata <= 16'd0;
			end
		end
 
    end
endmodule
