function s = print_decimal(x)
    if x==0
        s = '0d0';
        return
    end
    sign = abs(x)/x; 
    i = floor(abs(x));
    d = round(abs(x)-i,1)*10;
    s = sprintf('%.0fd%.0f',sign*i,d);
end
