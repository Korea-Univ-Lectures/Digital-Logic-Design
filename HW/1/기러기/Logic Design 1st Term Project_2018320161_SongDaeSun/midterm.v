module midterm( input [16:0] SW, output [8:0] LEDG,output reg [0:6] HEX7,HEX6, HEX5,HEX4, HEX1,HEX0);
reg [3:0] alarge, asmall, blarge, bsmall; 
wire [3:0] addsmall, addlarge; //result of addition (large is first digit, small is second digit)
wire [3:0] subsmall, sublarge; //result of substraction
wire overflow, underflow, led; //overflow & underflow. They are shown by LED
wire w1,w2,w3;
reg operator;//operator 0:addition, 1:substraction

BCDtwobyteAdder (alarge,asmall,blarge,bsmall, addlarge, addsmall, overflow);
//add operation

BCDtwoSubstractor (alarge,asmall,blarge,bsmall,sublarge, subsmall, underflow);
//substract operation

parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000;
parameter Seg7 = 7'b000_1111; parameter Seg6 = 7'b010_0000;
parameter Seg5 = 7'b010_0100; parameter Seg4 = 7'b100_1100;
parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010;
parameter Seg1 = 7'b100_1111; parameter Seg0 = 7'b000_0001;

always @(*)
begin
	alarge = SW[15:12];//left first number input
	asmall = SW[11:8];//left second number input
	blarge = SW[7:4];//right first number input
	bsmall = SW[3:0];//right second number input
	operator=SW[16];//operator
end

always @(*)
begin
	case(SW[15:12])//left first input
		9:HEX7=Seg9;    8:HEX7=Seg8;	7:HEX7=Seg7;	6:HEX7=Seg6;
		5:HEX7=Seg5;	4:HEX7=Seg4;	3:HEX7=Seg3;	2:HEX7=Seg2;
		1:HEX7=Seg1;	0:HEX7=Seg0;  default: HEX7 = 7'b1111111;
	endcase
	case(SW[11:8])//left second input
		9:HEX6=Seg9;	8:HEX6=Seg8;	7:HEX6=Seg7;	6:HEX6=Seg6;
		5:HEX6=Seg5;	4:HEX6=Seg4;	3:HEX6=Seg3;	2:HEX6=Seg2;
		1:HEX6=Seg1;	0:HEX6=Seg0;	default: HEX6 = 7'b1111111;
	endcase
	case(SW[7:4])//right first input
		9:HEX5=Seg9;     8:HEX5=Seg8;	7:HEX5=Seg7;	6:HEX5=Seg6;
		5:HEX5=Seg5;	4:HEX5=Seg4;	3:HEX5=Seg3;	2:HEX5=Seg2;
		1:HEX5=Seg1;	0:HEX5=Seg0;  default: HEX5 = 7'b1111111;
	endcase
	case(SW[3:0])//right secind input
		9:HEX4=Seg9;	8:HEX4=Seg8;	7:HEX4=Seg7;	6:HEX4=Seg6;
		5:HEX4=Seg5;	4:HEX4=Seg4;	3:HEX4=Seg3;	2:HEX4=Seg2;
		1:HEX4=Seg1;	0:HEX4=Seg0;	default: HEX4 = 7'b1111111;
	endcase
	
	if(operator ==0)//addition
		begin
		case(addlarge)//first digit of result
			9:HEX1=Seg9;	8:HEX1=Seg8;	7:HEX1=Seg7;	6:HEX1=Seg6;
			5:HEX1=Seg5;	4:HEX1=Seg4;	3:HEX1=Seg3;	2:HEX1=Seg2;
			1:HEX1=Seg1;	0:HEX1=Seg0;	default: HEX1 = 7'b1111111;
		endcase
		case(addsmall)//second digit of result
			9:HEX0=Seg9;	8:HEX0=Seg8;	7:HEX0=Seg7;	6:HEX0=Seg6;
			5:HEX0=Seg5;	4:HEX0=Seg4;	3:HEX0=Seg3;	2:HEX0=Seg2;
			1:HEX0=Seg1;	0:HEX0=Seg0;	default: HEX0 = 7'b1111111;
		endcase
	end
	else//substraction
		begin
		case(sublarge)//first digit of result
			9:HEX1=Seg9;	8:HEX1=Seg8;	7:HEX1=Seg7;	6:HEX1=Seg6;
			5:HEX1=Seg5;	4:HEX1=Seg4;	3:HEX1=Seg3;	2:HEX1=Seg2;
			1:HEX1=Seg1;	0:HEX1=Seg0;	default: HEX1 = 7'b1111111;
		endcase
		case(subsmall)//second digit of result
			9:HEX0=Seg9;	8:HEX0=Seg8;	7:HEX0=Seg7;	6:HEX0=Seg6;
			5:HEX0=Seg5;	4:HEX0=Seg4;	3:HEX0=Seg3;	2:HEX0=Seg2;
			1:HEX0=Seg1;	0:HEX0=Seg0;	default: HEX0 = 7'b1111111;
		endcase
	end
end

//control LED output (start)
not(w1, operator);
and(w2, w1, overflow);
and(w3, operator, underflow);
or (led, w2,w3);

assign LEDG[8]=led;
//control LED output (end)

endmodule


module full_adder(sum, car, a, b, cin);
output [3:0] sum;
output car;
input [3:0] a, b;
input cin;
wire [2:0] c;

assign sum[0]=a[0] ^ b[0] ^ cin;
assign c[0]=((a[0] ^ b[0]) & cin) | (a[0] & b[0]);

assign sum[1]=a[1] ^ b[1] ^ c[0];
assign c[1]=((a[1] ^ b[1]) & c[0]) | (a[1] & b[1]);

assign sum[2]=a[2] ^ b[2] ^ c[1];
assign c[2]=((a[2] ^ b[2]) & c[1]) | (a[2] & b[2]);

assign sum[3]=a[3] ^ b[3] ^ c[2];
assign car=((a[3] ^ b[3]) & c[2]) | (a[3] & b[3]);

endmodule

//BCD Adder
//This BCD consists of two Full adders
module BCD_adder(sum, car, a, b, cin);

output [3:0] sum;//final result output
output car;//final carry output
input [3:0] a, b;//input BCDs
input cin;//input Carry

wire carryfromfirst;//Carry from first Fulladder 

wire [3:0] resultfromfirst;//Number of digits of 1
reg [3:0] sixadder;//if result of add(a,b) is over 9, BCD adder adds 6,
//sixadder=6, else then sixadder=0

wire get82; //is 1 if result of add(a,b) is 10, 11, 14, 15
wire get84; //is 1 if result of add(a,b) is 12, 13, 14, 15

wire trashCarry;//useless carry from last Adder
//this carry is useless

reg zero;
//value 0

always @(*)
begin
	//set sixadder
	sixadder[3] = 1'b0;
	sixadder[0] = 1'b0;
	sixadder[1] <= car;
	sixadder[2] <= car;
	zero = 1'b0;
end

//set first full adder
full_adder firstFulladder(resultfromfirst, carryfromfirst, a,b,cin);

//Define Number of digits of 10
and(get84, resultfromfirst[3],resultfromfirst[2]);
and(get82, resultfromfirst[3], resultfromfirst[1]);
or(car, carryfromfirst, get84, get82);

//set last full adder
full_adder lastFulladder(sum, trashCarry, sixadder, resultfromfirst,zero);
//The last adder adding doesn`t need carry

endmodule

//return 9`s complement of input a
module ninesComplement (a, com);

//9`s complement of a
output [3:0] com;

wire inw, inx, iny;

input [3:0] a;

//define 9`s complement for one digit
//this definition comes from k-map that I made
not (com[0],a[0]);
assign com[1]=a[1];
xor (com[2], a[2],a[1]);
not(inw,a[3]);
not(inx, a[2]);
not (iny, a[1]);
and (com[3],  inw, inx, iny);

endmodule

//BCD adder with 2digits + 2digits = 2digits
//This adder has two full adder
module BCDtwobyteAdder (alarge,asmall,blarge,bsmall, rlarge, rsmall,car);
//operation:(alarge*10+asmall)+(blarge*10+bsmall)=(rlarge*10+rsmall)

input [3:0] alarge,asmall,blarge,bsmall;
output [3:0] rlarge, rsmall;
output car;

reg cbase;//carry input for first fulladder which is 0
wire caddsmall;//carry output for first fulladder & carry input for last fulladder

always @(*)
begin
	//set cbase to 0
	cbase=1'b0;
end

//frist, add Number of digits of 1
BCD_adder smallAdder (rsmall, caddsmall, asmall, bsmall, cbase);

//second, add Number of digits of 10
BCD_adder largeAdder (rlarge, car, alarge, blarge, caddsmall);

endmodule

//return 10`s complement for two digits
//first, get 9`s complements for each digits
//second, add 1 to 9`s complements of given inputs to get 10`s complement
module tensComplement (inlarge,insmall,comlarge,comsmall, car);
input [3:0] inlarge,insmall;
output [3:0] comlarge,comsmall;
output car;//some value is need to show whether input is 0 or not
//because 10`s complement of 00 has carry (need 3 digits)

wire [3:0] ninelarge, ninesmall;//9`s complement for each digits

//store 1 to add 9`s complement
reg [3:0] onelarge;
reg [3:0] onesmall;

always @(*)
begin
//set onelarge to 1
onelarge[3]=1'b0;
onelarge[2]=1'b0;
onelarge[1]=1'b0;
onelarge[0]=1'b0;

onesmall[3]=1'b0;
onesmall[2]=1'b0;
onesmall[1]=1'b0;
onesmall[0]=1'b1;
end

ninesComplement(inlarge, ninelarge); //get 9`s complement of Number of digits of 10
ninesComplement(insmall, ninesmall); //get 9`s complement of Number of digits of 1

//add(1, 9`s complement of input) to get 10`s complement of input
BCDtwobyteAdder(ninelarge,ninesmall,onelarge,onesmall,comlarge,comsmall,car);

endmodule

//BCD substractor for two digits
//We assumme that first number(a) is larger than second number(b)
//If second number(b)is 0, than all cases are valid regardlees what first number(a) is
module BCDtwoSubstractor (alarge,asmall,blarge,bsmall,rlarge, rsmall, underflow);
input [3:0] alarge,asmall,blarge,bsmall;
output [3:0] rlarge, rsmall;
output underflow;

wire [3:0] comlarge, comsmall;//10`s complement of second number(b)
wire carofaddition, zeroexception, car;
//carofaddition is 1 when first number(a)>=second number(b)
//zeroexception is 1 when second number(b) is 0

reg basecarry;//carry input which is 0

tensComplement (blarge,bsmall,comlarge,comsmall,zeroexception);
//get 10`s complement of second number(b)

BCDtwobyteAdder (alarge,asmall,comlarge,comsmall, rlarge, rsmall,carofaddition);
//add first number(a) and 10`s complement of second number(b)

or (car, carofaddition, zeroexception);
not (underflow, car);
//inverter is needed because valid substraction occurs carry

endmodule