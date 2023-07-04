function fs = get_flutter_speed(data,opts)
arguments
    data
    opts.filter = {};
    opts.NModes = [];
    opts.XAxis = 'V';
    opts.YAxis = 'D';
    opts.Mode = 'MODE';
    opts.Delta = 0;
end
    if isempty(opts.NModes)
        opts.NModes = max([data.(opts.Mode)]);
    end
    if ~isempty(opts.filter)
        data = farg.struct.filter(data,opts.filter);
    end
    fs = inf;    
    for i = 1:opts.NModes
        I = [data.MODE] == i;
        x = [data(I).(opts.XAxis)];
        D = [data(I).(opts.YAxis)];
        [~,I] = sort(x);
        tmp_fs = find_crossing(x(I),D(I)-opts.Delta);
        if ~isnan(tmp_fs)
            if tmp_fs < fs
                fs = tmp_fs;
            end
        end     
    end
end

function x_cross = find_crossing(x,y)
    x_cross = nan;
    if isempty(x) || isempty(y) || length(x)~=length(y)
        return
    end
    sign = y(1)/abs(y(1));
    for i = 2:length(x)
        if sign*y(i)<0
            m = (y(i)-y(i-1))/(x(i)-x(i-1));
            x_cross = x(i-1)-y(i-1)/m;
            break;
        end
    end
end

