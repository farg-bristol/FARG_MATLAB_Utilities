function fs = get_flutter_speed(data,varargin)
    p = inputParser();
    p.addParameter('filter',{});
    p.addParameter('NModes',[]);
    p.addParameter('XAxis','V');
    p.addParameter('YAxis','D');
    p.addParameter('Mode','MODE');
    p.addParameter('Delta',0);
    p.parse(varargin{:})
    if isempty(p.Results.NModes)
        p.parse('NModes',max([data.(p.Results.Mode)]),varargin{:})
    end
    if ~isempty(p.Results.filter)
        data = farg.struct.filter(data,p.Results.filter);
    end
    fs = inf;    
    for i = 1:p.Results.NModes
        I = [data.MODE] == i;
        x = [data(I).(p.Results.XAxis)];
        D = [data(I).(p.Results.YAxis)];
        [~,I] = sort(x);
        tmp_fs = find_crossing(x(I),D(I)-p.Results.Delta);
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

