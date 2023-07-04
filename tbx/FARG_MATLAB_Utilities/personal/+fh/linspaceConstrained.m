function vals = linspaceConstrained(xs,N)
if N<length(xs)
    error('N less than length of array')
elseif N == length(xs)
    vals = xs;
    return
end
N = N - length(xs);
delta = xs(2:end)-xs(1:end-1);
delta = delta./(xs(end)-xs(1));
Ns = round(delta*N);
while sum(Ns)~= N
    if sum(Ns)>N
        [~,idx] = max(Ns);
        Ns(idx) = Ns(idx)-1;
    else
        [~,idx] = min(Ns);
        Ns(idx) = Ns(idx)+1;
    end
end
vals = linspace(xs(1),xs(2),2+Ns(1));
for i = 2:length(xs)-1
    tmp = linspace(xs(i),xs(i+1),2+Ns(i));
    vals = [vals,tmp(2:end)];
end
end