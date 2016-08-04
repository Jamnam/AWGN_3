%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Evaluate e = -2ln(u0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Range Reduction
exp_e = lzd(u0,48)+1;
x_e = bitsll(u0,exp_e);
%Approximate ln(x_e) where x_e = [1,2)
%Degree-2 piecewise polynomial

%Seperate x_e to x_e_A and x_e_B
x_e = dec2bin(x_e);
x_e_A = x_e(2:9);
x_e_B = [x_e(10:49)];
x_e_A = bin2dec(x_e_A);
x_e_B = bin2dec(x_e_B);

sqr_B = x_e_B^2;
sqr_B = floor(sqr_B/2^40);
% sqr_B = dec2bin(sqr_B);
% lsq = length(sqr_B);
% if (lsq>=40) sqr_B = sqr_B(1:lsq-40);
% else sqr_B = '0000000000000000000000000000000000000000';
% end
% sqr_B = bin2dec(sqr_B);
prod2 = sqr_B* bin2dec(rom_c2e(x_e_A+1,:));
prod2 = floor(prod2/2^40);
% prod2 = dec2bin(prod2);
% lp2 = length(prod2);
% if (lp2 >= 13) prod2 = prod2(1:lp2-40);
% else prod2 = '0000000000000';
% end
% prod2 = ['00000000000000000',prod2];
%comp2 = bitcmp(uint32(bin2dec(prod2)))+1;
%x_e = bin2dec(x_e)/2^48;

prod1 = x_e_B * bin2dec(rom_c1e(x_e_A+1,:));
prod1 = floor(prod1/2^40);
% prod1 = dec2bin(prod1);
% lp1 = length(prod1);
% if (lp1 >= 22) prod1 = prod1(1:lp1-40);
% else prod1 = '0000000000000000000000';
% end
% prod1 = ['00000000',prod1];
% prod1 = bin2dec(prod1);

%y_e = C2_e(x_e_A+1)*x_e_B^2 + C1_e(x_e_A+1)*x_e_B+C0_e(x_e_A+1);
y_e = -prod2 + prod1 + bin2dec(rom_c0e(x_e_A+1,:));

%Range Reconstruction
ln2 = '10110001011100100001011111110111';
e1 = exp_e * bin2dec(ln2);
e = floor((e1 - y_e*4)/128);