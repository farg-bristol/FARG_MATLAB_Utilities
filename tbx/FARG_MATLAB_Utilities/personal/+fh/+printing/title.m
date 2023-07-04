function title(str,opts)
arguments
    str char
    opts.fid = 1;
    opts.Length = 80;
end

if length(str)>=opts.Length
    fprintf(opts.fid,[str,'\n']);
elseif length(str) == opts.Length-1
    fprintf(opts.fid,[' ',str,'\n']);
elseif length(str) == opts.Length-2
    fprintf(opts.fid,[' ',str,' \n']);
elseif length(str) == opts.Length-3
    fprintf(opts.fid,['- ',str,' \n']);
else
    delta = opts.Length-(length(str)+2);
    dashes = repmat('-',1,floor(delta/2));
    if mod(delta,2) == 0
        fprintf(opts.fid,[dashes,' ',str,' ',dashes,'\n']);
    else
        fprintf(opts.fid,[dashes,' ',str,' -',dashes,'\n']);
    end
end
end

