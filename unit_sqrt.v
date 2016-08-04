`timescale 1ns / 1ps
module unit_sqrt(
    input clk,
    input rst,
	input [30:0] e,
	output [16:0] f 
);

wire [4:0] sb; //The number of bits need to be shifted;
wire [5:0] compsb; //The complementary form of sb;

wire [5:0] exp_f;
wire [4:0] exp_ff;
wire [30:0] x_f;
wire [5:0] x_f_A;
wire [18:0] x_f_B;
reg [18:0] xB;

wire [29:0] prod; //The product of c1 and x_e_B;
wire [19:0] y_f;
wire [22:0] ff;

wire [10:0] c10,c11,c1;
wire [19:0] c00,c01,c0;
reg [10:0] c1r;
reg [19:0] c0r1,c0r2,c0r3;

reg [29:0] prodr1,prodr2;
wire v;

reg [5:0] exp_fr1,exp_fr2,exp_fr3;

//DUT mapping
rom_c1f0 rom1(
	.addr(x_f_A),
	.c1f0(c10)
);

rom_c0f0 rom2(
	.addr(x_f_A),
	.c0f0(c00)
);

rom_c1f1 rom3(
	.addr(x_f_A),
	.c1f1(c11)
);

rom_c0f1 rom4(
	.addr(x_f_A),
	.c0f1(c01)
);

lzd32 m0(
	.a({1'b0,e}),
	.p(sb),
	.v(v)
);


shiftere m1(
	.e(e),
	.exp_f(exp_f),
	.x_f1(x_f)
);


shiftery_f m2(
	.y_f(y_f),
	.exp_ff(exp_ff),
	.ff(ff)
);


assign c1 = (exp_f[0])?c10:c11;
assign c0 = (exp_f[0])?c00:c01;

assign compsb = ~{1'b0,sb}+6'b00_0001;

//sb is substract by 6 becuase the lzd used here is 32bits 
//instead of 31bits.
assign exp_f = 6'b00_0110 + compsb; 

assign x_f_A = x_f[24:19];
assign x_f_B = x_f[18:0];

always @(posedge clk or negedge rst)begin
if(~rst)begin
    prodr1 <= 0;
    prodr2 <= 0;
    xB <= 0;
    c1r <= 0;
    c0r1 <= 0;
    c0r2 <= 0;
    c0r3 <= 0;
    exp_fr1 <= 0;
    exp_fr2 <= 0;
    exp_fr3 <= 0;
    end
    else begin
    prodr1 <= prod;
    prodr2 <= prodr1;
    xB <= x_f_B;
    c1r <= c1;
    c0r1 <= c0;
    c0r2 <= c0r1;
    c0r3 <= c0r2;
    exp_fr1 <= exp_f;
    exp_fr2 <= exp_fr1;
    exp_fr3 <= exp_fr2;
    end
end

assign prod = c1r*xB;
assign y_f =(exp_fr3[0])?prodr2[29:18]+c0r3:prodr2[29:17]+c0r3;

assign exp_ff = (exp_fr3[0])?exp_fr3+5'b0_0001>>1:exp_fr3>>1; 
assign f = (v)?ff[22:6]:17'b0_0000_0000_0000_0000;

endmodule




