module logic_design( input [4:0] SW, input CLOCK_50,output reg [0:6] HEX3, HEX1,HEX0);

	//parameters for HEXs
	parameter Seg8 = 7'b000_0000;
	parameter Seg6 = 7'b010_0000;
	parameter Seg4 = 7'b100_1100;
	parameter Seg2 = 7'b001_0010;
	parameter Seg1 = 7'b100_1111;
	parameter Seg0 = 7'b000_0001;

	//parameters for State
	parameter S0=3'b000;
	parameter S4=3'b001;
	parameter S8=3'b010;
	parameter S12=3'b011;
	parameter S16=3'b100;
	parameter S20=3'b101;
	
	
	wire [2:0] state;//State reg
	wire newclk;//long clock
	wire [4:0] filteredInput;//if input doesn`t change in differnt clock, then ignore that input
	
	clock(CLOCK_50, newclk);//get a long clock
	inputChecker(SW, newclk, filteredInput);//get the input that changes when the clock changes.
	calcula(filteredInput,newclk,state);//get proper state
	
	always @(*)
	begin
		case(state)//show state(waiting people) and output(possible ride number)
				   //waiting people number and possible ride number are only depended on state
			S0:begin HEX3=Seg0; HEX1=Seg0; HEX0=Seg0; end
			S4:begin HEX3=Seg0; HEX1=Seg0; HEX0=Seg4; end
			S8:begin HEX3=Seg1; HEX1=Seg0; HEX0=Seg8; end
			S12:begin HEX3=Seg1; HEX1=Seg1; HEX0=Seg2; end
			S16:begin HEX3=Seg2; HEX1=Seg1; HEX0=Seg6; end
			S20:begin HEX3=Seg2; HEX1=Seg2; HEX0=Seg0; end
			default: begin HEX3=7'b111_1111; HEX1=7'b111_1111; HEX0=7'b111_1111; end
		endcase	
	end
endmodule

//check whether input has changed
module inputChecker (input [4:0] in, input clk, output [4:0]out);

reg [4:0] currentInput;//current input which means flitered output
reg [4:0] previousInput;//previous input which means the input that has just affected the state

//Initialization currentInput, previousInput to "There is no input"
initial 
	currentInput=5'b00000;
initial 
	previousInput=5'b00000;
	

always @(posedge clk)
begin
	if(previousInput==in)//if previousInput equals the input from switch,
		currentInput<=5'b00000;//then the output of this module is "There is no input".
	else//if previousInput doesn`t equal the input from switch,
	begin
		if(in==5'b00001)//and if the input from switch is SW[0]
		begin
			currentInput<=5'b00001;//then set currentInput to SW[0]
			previousInput<=5'b00001;//and set previousInput to SW[0]
		end
		
		else if(in==5'b00010)//and if the input from switch is SW[1]
		begin
			currentInput<=5'b00010;//then set currentInput to SW[1]
			previousInput<=5'b00010;//and set previousInput to SW[1]
		end
		
		else if(in==5'b00100)//and if the input from switch is SW[2]
		begin
			currentInput<=5'b00100;//then set currentInput to SW[2]
			previousInput<=5'b00100;//and set previousInput to SW[2]
		end
		
		else if(in==5'b01000)//and if the input from switch is SW[3]
		begin
			currentInput<=5'b01000;//then set currentInput to SW[3]
			previousInput<=5'b01000;//and set previousInput to SW[3]
		end
		
		else if(in==5'b10000)//and if the input from switch is SW[4]
		begin
			currentInput<=5'b10000;//then set currentInput to SW[4]
			previousInput<=5'b10000;//and set previousInput to SW[4]
		end
		
		else//if there is no input such as SW[0], SW[1], SW[2], SW[3], SW[4]
		begin
			currentInput<=5'b00000;//then regard as "There is no input"
			previousInput<=5'b00000;//then regard as "There is no input"
		end
	end
end

assign out=currentInput;//assign currentInput to out

endmodule

//Increase the clock spacing
module clock(input clk, output newclk);
	reg [23:0]cnt;//reg for increasement for clock
	
	always@(posedge clk)
	begin
		cnt <= cnt + 1'b1;//add 1 to the reg at each clock
	end
	
	assign newclk = cnt[23];//output is 1 at 2^22 per 1 clock
endmodule

module calcula(input [4:0] in, input clk, output [2:0] out);
	
	//parameters for state
	parameter S0=3'b000;
	parameter S4=3'b001;
	parameter S8=3'b010;
	parameter S12=3'b011;
	parameter S16=3'b100;
	parameter S20=3'b101;
	
	reg [2:0] currentState;//current state
	reg [2:0] nextState;//next state

always @(*)
	begin
		if (in==5'b10000)//if input is SW[4]
			nextState<=S0;//then reset
		
		else if(in==5'b00001)//if input is SW[0]
		begin//then change state considering the diagram
			case(currentState)
			S0:nextState<=S4;
			S4:nextState<=S8;
			S8:nextState<=S12;
			S12:nextState<=S16;
			S16:nextState<=S20;
			S20:nextState<=S20;
			default nextState<=currentState;
		endcase	
		end
		
		else if(in==5'b00010)//if input is SW[1]
		begin//then change state considering the diagram
			case(currentState)
			S0:nextState<=S8;
			S4:nextState<=S12;
			S8:nextState<=S16;
			S12:nextState<=S20;
			S16:nextState<=S16;
			S20:nextState<=S20;
			default nextState<=currentState;
		endcase	
		end
		
		else if(in==5'b00100)//if input is SW[2]
		begin//then change state considering the diagram
			case(currentState)
			S0:nextState<=S12;
			S4:nextState<=S16;
			S8:nextState<=S20;
			S12:nextState<=S12;
			S16:nextState<=S16;
			S20:nextState<=S20;
			default nextState<=currentState;
		endcase	
		end
		
		else if(in==5'b01000)//if input is SW[3]
		begin//then change state considering the diagram
			case(currentState)
			S0:nextState<=S0;
			S4:nextState<=S4;
			S8:nextState<=S0;
			S12:nextState<=S4;
			S16:nextState<=S8;
			S20:nextState<=S12;
			default nextState<=currentState;
		endcase	
		end
		
		else 
		begin
			nextState<=currentState;
		end
	end
		
	assign out = currentState;

	//initial currentState to S0
	initial
		currentState=S0;
	
	always@(posedge clk)//change currentState to nextState for each clock positive edge 
	begin
		currentState <= nextState;
	end
	
endmodule
