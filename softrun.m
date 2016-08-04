x0s = zeros(1,10000);
s1 = uint32(2147483648);
s2 = uint32(2147483648);
s3 = uint32(2147483648);

s4 = uint32(2147483648);
s5 = uint32(2147483648);
s6 = uint32(2147483648);
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
    u0 = hex2dec(ab(1:12))/2^48;
    u1 = hex2dec(ab(13:16))/2^16;
    
    es = -2*log(u0);
    fs = sqrt(es);
    g0s = sin(2*pi*u1);
    x0s(n) = fs.*g0s;

end