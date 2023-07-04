function x = OneMinusCosine(f,delay,t)
x = zeros(size(t));
idx = t>=delay & t<=(delay+1/f);
x(idx) = 0.5*(1-cos(2*pi*f*t(idx)));
end

