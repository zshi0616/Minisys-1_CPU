`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds(led_clk,ledrst,ledwrite,ledaddrcs,ledwdata,ledout);
    input led_clk,ledrst;
    input ledwrite;
    input ledaddrcs;
    input[15:0] ledwdata;
    output[15:0] ledout;
    
    reg [15:0] ledout;
    
	//��MOOC 13��
    always@(posedge led_clk or posedge ledrst) begin
		if (~ledrst)
		begin
			ledout <= 16'd0;
		end
		else
		begin
			if (ledaddrcs==1'b1)
			begin
				if (ledwrite==1'b1)
					ledout <= ledwdata;
				else
					ledout <= ledout;
			end
			else
				ledout <= 16'd0;
		end
    end
endmodule
