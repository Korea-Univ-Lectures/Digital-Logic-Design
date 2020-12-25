module four_bit_swift (input [1:0]SW , input CLOCK_50 , output wire [7:4]LEDG );
	wire newClk;

	clock(CLOCK_50, newClk);//NEW CLOCK

	d_flip_flop u0 (SW[0], newClk, SW[1], LEDG[7]); //SW[0] for input, SW[1] for reset
	d_flip_flop u1 (LEDG[7], newClk, SW[1], LEDG[6]);
	d_flip_flop u2 (LEDG[6], newClk, SW[1], LEDG[5]);
	d_flip_flop u3 (LEDG[5], newClk, SW[1], LEDG[4]);
endmodule

module d_flip_flop ( input din ,input clk ,input reset ,output reg dout );
	always @ (posedge clk)
	begin
		if (reset)
			dout <= 0;
		else
			dout <= din;
	end
endmodule 

module clock(input clk, output newclk);
	reg [24:0]cnt;
	
	always@(posedge clk)
	begin
		cnt <= cnt + 1'b1;
	end
	assign newclk = cnt[24];
endmodule
