`timescale 1ns / 1ps
module urng(
	input [31:0] seed0,
	input [31:0] seed1,
	input [31:0] seed2,
	input clk,
	input rst,
	output  [31:0] rnd
);

wire [31:0] s0, s1, s2;
reg [31:0] a0,a1,a2;
wire [31:0] b0,b1,b2;
wire [31:0] c0,c1,c2;
wire [31:0] d0,d1,d2;
wire [31:0] e0,e1,e2;
wire [31:0] f0,f1,f2;



//All seeds set to the input value when reset is high;
always @(posedge clk or negedge rst) begin
	if(~rst) begin
		a0 <= seed0;
		a1 <= seed1;
		a2 <= seed2;
	end
	else begin
		a0 <= s0;
		a1 <= s1;
		a2 <= s2;
	end
end


//The URNG is based on LFSRs
assign b0 = a0 << 13;
assign c0 = a0 ^ b0;
assign d0 = a0 & 32'hffff_fffe;
assign e0 = c0 >> 19;
assign f0 = d0 <<12;
assign s0 = e0 ^ f0;

assign b1 = a1 << 2;
assign c1 = a1 ^ b1;
assign d1 = a1 & 32'hffff_fff8;
assign e1 = c1 >> 25;
assign f1 = d1 << 4;
assign s1 = e1 ^ f1;

assign b2 = a2 << 3;
assign c2 = a2 ^ b2;
assign d2 = a2 & 32'hffff_fff0;
assign e2 = c2 >> 11;
assign f2 = d2 << 17;
assign s2 = e2 ^ f2;

assign rnd = s0 ^ s1 ^ s2;


endmodule
