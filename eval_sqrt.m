%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Evaluate f = sqrt(e)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Range Reduction
exp_f = 5-lzd(e,31);
x_f1 =  floor(e*2^(-exp_f));
x_f = x_f1;
% if mod(exp_f,2)
%     x_f = x_f1/2;
% else
%     x_f = x_f1;
% end

%Approximate sqrt(f) where x_f = [1,4)
%Degree-1 piecewise polynomial
x_f = dec2bin(x_f);
l = length(x_f);

if l==25
    x_f_A = x_f(2:7);
    x_f_B = x_f(8:25);
else
    x_f_A = x_f(2:7);
    x_f_B = x_f(8:26);
end

x_f_A = bin2dec(x_f_A);
x_f_B = bin2dec(x_f_B);
%x_f = bin2dec(x_f)/2^24;
%prod = bin2dec(rom_c1f0(x_f_A+1,:))*x_f_B;
if mod(exp_f,2)
    y_f = floor((bin2dec(rom_c1f0(x_f_A+1,:))*x_f_B)/2^18)+bin2dec(rom_c0f0(x_f_A+1,:));
else
    y_f = floor((bin2dec(rom_c1f1(x_f_A+1,:))*x_f_B)/2^17)+bin2dec(rom_c0f1(x_f_A+1,:));
end

%Range Reconstruction
if mod(exp_f,2)
    exp_f1 = (exp_f+1)/2;
else
    exp_f1 = exp_f/2;
end

f = floor(y_f * 2^(exp_f1)/64);