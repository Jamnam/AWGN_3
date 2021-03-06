clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_coeff;
rom_gen;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1 = uint32(2147483648);
s2 = uint32(2147483648);
s3 = uint32(2147483648);

s4 = uint32(2147483648);
s5 = uint32(2147483648);
s6 = uint32(2147483648);

x0 = zeros(1,10000);
x0f = zeros(1,10000);
x1 = zeros(1,10000);

x0s = zeros(1,10000);

for n=1:10000
    
    [a,s1,s2,s3] = taus(s1,s2,s3);
    [b,s4,s5,s6] = taus(s4,s5,s6);
    a = dec2hex(a);
    b = dec2hex(b);
    l_a = length(a);
    l_b = length(b);
    n_a = 8-l_a;
    n_b = 8-l_b;
    
    if (n_a>0)
        for k=1:n_a
            a = cat(2,'0',a);
        end
    end
    
    if (n_b>0)
        for k= 1:n_b
            b = cat(2,'0',b);
        end
    end
    
    ab = [a,b];
    u0 = hex2dec(ab(1:12));
    u1 = hex2dec(ab(13:16));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Evaluationg using matlab funcion directly 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    u0fp = u0/2^48;
    u1fp = u1/2^16;
    efp = -2*log(u0fp);
    ffp = sqrt(efp);
    g0fp = sin(2*pi*u1fp);
    x0s(n) = ffp.*g0fp;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Evaluate e = -2ln(u0)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eval_log;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Evaluate f = sqrt(e)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eval_sqrt;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Evaluate g0=sin(2*pi*u1),g1=cos(2*pi*u1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eval_cos;
    
    fg = floor(f*g0/2^17);
    if (fg>=0) x0(n)=fg;
    else x0(n) = double(bitcmp(uint16(-fg))+1);
    end
    %x0(n) = floor(f*g0/2^17);
    x0f(n) = fg/2^11;
    x1(n) = floor(f*g1/2^17);
    
  
end

figure;
histogram(x0f,100);
figure;
err = x0s-x0f;
plot(err);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Kolmogorov-Smirnov test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ks;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Write data into text file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
soft_out = zeros(10000,1);
x00 = dec2bin(x0);

for n=1:10000
    soft_out(n) = str2double(x00(n,:));
end


fid = fopen('soft_out.txt','wt');
fprintf(fid,'%d\n',soft_out); 
fclose(fid);
