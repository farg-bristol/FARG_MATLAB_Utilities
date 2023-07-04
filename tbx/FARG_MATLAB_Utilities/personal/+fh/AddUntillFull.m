function vals = AddUntillFull(vals,gap)
delta = vals(2:end)-vals(1:end-1);
[md,idx] = max(abs(delta));
while md>gap
    new_val = vals(idx) + (vals(idx+1)-vals(idx))*0.5;
    vals = [vals(1:idx),new_val,vals((idx+1):end)];
    delta = vals(2:end)-vals(1:end-1);
    [md,idx] = max(abs(delta));
end
end