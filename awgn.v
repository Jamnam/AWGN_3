`timescale 1ns / 1ps
module awgn(
	input clk,
	input rst,
	input [31:0] urng_seed1,
	input [31:0] urng_seed2,
	input [31:0] urng_seed3,
	input [31:0] urng_seed4,
	input [31:0] urng_seed5,
	input [31:0] urng_seed6,
	output reg [15:0] awgn_out
);

wire [31:0] a,b;
wire [47:0] u0;
wire [15:0] u1;
wire [30:0] e;
wire [16:0] f;
wire [15:0] g0;
wire [32:0] fg; //Product of f and g0;
wire sign;  //The MSB(Sign bit)of output;
wire [32:0] fg_s; //The compementary form of fg and shifted to the same bit as output;

reg [32:0] fgr;
reg [47:0] u0r;
reg [15:0] u1r,u1r1,u1r2,u1r3,u1r4,u1r5,u1r6,u1r7,u1r8,u1r9;
reg [30:0] er;
reg [16:0] fr1,fr2;
reg signr;


//DUT mapping
urng m1(
	.seed0(urng_seed1),
	.seed1(urng_seed2),
	.seed2(urng_seed3),
	.clk(clk),
	.rst(rst),
	.rnd(a)
);

urng m2(
	.seed0(urng_seed4),
	.seed1(urng_seed5),
	.seed2(urng_seed6),
	.clk(clk),
	.rst(rst),
	.rnd(b)
);

unit_log m3(
    .clk(clk),
    .rst(rst),
	.u0(u0r),
	.e(e)
);

unit_cos m4(
	.clk(clk),
	.rst(rst),
	.u1(u1r),
	.g0(g0),
	.sign(sign)
);

unit_sqrt m5(
    .clk(clk),
    .rst(rst),
	.e(er),
	.f(f)
);


always @(posedge clk or negedge rst)begin
if(~rst) begin
    u0r <= 0;
    u1r1 <= 0;
    u1r2 <= 0;
    u1r3 <= 0;
    u1r4 <= 0;
    u1r5 <= 0;
    u1r6 <= 0;
    u1r7 <= 0;
    u1r8 <= 0;
    u1r9 <= 0;
    u1r <= 0;
    er <= 0;
    fr1 <= 0;
    fr2 <= 0;
    fgr <= 0;
    signr <= 0;
    end
    else begin
    u0r <= u0;
    u1r1 <= u1;
    u1r2 <= u1r1;
    u1r3 <= u1r2;
    u1r4 <= u1r3;
    u1r5 <= u1r4;
    u1r6 <= u1r5;
    u1r7 <= u1r6;
    u1r8 <= u1r7;
    u1r9 <= u1r8;
    u1r <= u1r9;
    er <= e;
    fr1 <= f;
    fr2 <= fr1;
    fgr <= fg;
    signr <= sign;
    end
end

assign u0 = {a,b[31:16]};
assign u1 = b[15:0];
//assign fg = reg_f*g0;
assign fg = fr2 * g0;
//assign fg_s = ~fg[32:17]+16'b0000_0000_0000_0001;
assign fg_s = ~fgr + 33'b0_0000_0000_0000_0000_0000_0000_0000_0001;

//Output the sample at the rising edge of clk
always @(posedge clk or negedge rst) begin
	if (~rst) begin
	   awgn_out <= 0;
	end
	else begin
	//awgn_out <= (sign)?fg_s:fg[32:17];
    awgn_out <= (signr)?fg_s[32:17]:fgr[32:17];
    end
end



endmodule
