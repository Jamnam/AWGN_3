`timescale 1ns / 1ps
module unit_log(
    input clk,
    input rst,
	input [47:0] u0,
	output [30:0] e
);

wire [5:0] exp_e;
wire [5:0] sb; //Number of bits should be shift
wire [47:0] x_e;

wire [29:0] y_e;
wire [37:0] e1;
wire [37:0] compy_e; //The complementary form of e
wire [37:0] diff_e; //The difference between e1 and y_e;
reg [5:0] exp_er;
wire [7:0] x_e_A;
wire [39:0] x_e_B;

wire [79:0] sqr_B; //The square of x_e_B;
wire [52:0] prod2; //The product of sqr_B and c2e;
wire [61:0] prod1; //The produce of x_e_B and c1e;
wire [29:0] comp2; //The complementary form of c2e*x^2;
wire [12:0] c2;  
wire [21:0] c1;
wire [29:0] c0;
wire v;

reg [79:0] sqr_Br1,sqr_Br2;
reg [52:0] prod2r1,prod2r2;
reg [61:0] prod1r1,prod1r2,prod1r3,prod1r4;
reg [12:0] c2r1,c2r2;
reg [21:0] c1r1;
reg [29:0] c0r1,c0r2,c0r3,c0r4;
reg [37:0] e1r1,e1r2,e1r3,e1r4;
reg [7:0] xA;
reg [39:0] xB,xB1,xB2;

parameter ln2 = 32'b1011_0001_0111_0010_0001_0111_1111_0111;

//DUT mapping
shifteru0 m0(
	.u0(u0),
	.exp_e(exp_e),
	.x_e(x_e)
);


lzd48 m1(
	.a(u0),
	.p(sb),
	.v(v)
);

rom_c2e rom2(
	.addr(xA),
	.c2e(c2)
);

rom_c1e rom1(
	.addr(xA),
	.c1e(c1)
);

rom_c0e rom0(
	.addr(xA),
	.c0e(c0)
);

always @(posedge clk or negedge rst)begin
if(~rst)begin
    sqr_Br1 <= 0;
    sqr_Br2 <= 0;
    xA <= 0;
    xB <= 0;
    xB1 <= 0;
    xB2 <= 0;
    prod2r1 <= 0;
    prod2r2 <= 0;
    prod1r1 <= 0;
    prod1r2 <= 0;
    prod1r3 <= 0;
    prod1r4 <= 0;
    c0r1 <= 0;
    c0r2 <= 0;
    c0r3 <= 0;
    c0r4 <= 0;
    c1r1 <= 0;
    c2r1 <= 0;
    c2r2 <= 0;
    e1r1 <= 0;
    e1r2 <= 0;
    e1r3 <= 0;
    e1r4 <= 0;
    exp_er <= 0;
    end
    else begin
    sqr_Br1 <= sqr_B;
    sqr_Br2 <= sqr_Br1;
    xA <= x_e_A;
    xB <= x_e_B;
    xB1 <= xB;
    xB2 <= xB1;
    prod2r1 <= prod2;
    prod2r2 <= prod2r1;
    prod1r1 <= prod1;
    prod1r2 <= prod1r1;
    prod1r3 <= prod1r2;
    prod1r4 <= prod1r3;
    c0r1 <= c0;
    c0r2 <= c0r1;
    c0r3 <= c0r2;
    c0r4 <= c0r3;
    c1r1 <= c1;
    c2r1 <= c2;
    c2r2 <= c2r1;
    e1r1 <= e1;
    e1r2 <= e1r1;
    e1r3 <= e1r2;
    e1r4 <= e1r3;
    exp_er <= exp_e;
    end
end

assign exp_e = sb + 6'b00_0001;
assign x_e_A = x_e[47:40];
assign x_e_B = x_e[39:0];

assign sqr_B = xB*xB;
assign prod2 = c2r2*sqr_Br2[79:40];
assign comp2 = ~{17'b0_0000_0000_0000_0000,prod2r2[52:40]}+30'b00_0000_0000_0000_0000_0000_0000_0001; 

assign prod1 = c1r1*xB1;

assign y_e = comp2+{8'b0000_0000,prod1r3[61:40]}+c0r4;

assign e1 = exp_er * ln2;

assign compy_e = ~{6'b00_0000,y_e,2'b00}+1;
assign diff_e = e1r4 + compy_e;
assign e = (v)?diff_e[37:7]:30'b00_0000_0000_0000_0000_0000_0000_0000; //e is 0 when u0 equals 0;

endmodule
