# AWGN_3

Run the awgn.m to generate bit-accurate sample from matlab. It also generate the floating point version of both intrinsic matlab fuction and Box-Muller method and compares the error. The figure "error.png" shows the error between floating point and fixed point. 
The matlab code outputs the "soft_out.txt" for Verilog Test Bench.

The Test bench "awgntb_err.v" simulate the RTL model and reads the text filr from matlab. Then it compares them and gives the result on screen. (For both match and mismatch).
