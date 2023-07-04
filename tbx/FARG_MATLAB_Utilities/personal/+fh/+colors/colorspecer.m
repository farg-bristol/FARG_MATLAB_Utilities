function [out,outlier] = colorspecer(N,Type,Set,opts)
arguments
    N
    Type {mustBeMember(Type,["qual","div","seq"])} = "qual"
    Set {SetVaildation(Set,Type)} = "Bright"
    opts.interp_method {mustBeMember(opts.interp_method,["nearest","linear","spline","cubic"])} = "linear"
    opts.etaStart = 0;
    opts.etaEnd = 1;
    opts.Flip = false;
end
% get color scheme
switch Type
    case "qual"
        [out,outlier] = getQualScheme(Set);
        if N>size(out,1)
            error('not enough colors in scheme (%.0f bu %.0f requested)',size(out,1),N)
        else
            if opts.Flip
                out = flipud(out);
            end
            out = out(1:N,:);
        end
    case "div"
        [out,outlier] = getDivScheme(Set);
        if opts.Flip
            out = flipud(out);
        end
        out = interp1(linspace(0,1,size(out,1)),out,linspace(opts.etaStart,opts.etaEnd,N),opts.interp_method);
    case "seq"
        [out,outlier] = getSeqScheme(Set);
        if opts.Flip
            out = flipud(out);
        end
        out = interp1(linspace(0,1,size(out,1)),out,linspace(opts.etaStart,opts.etaEnd,N),opts.interp_method);
end
out = out./255;
outlier = outlier./255;
end

function [out,outlier] = getQualScheme(Set)
switch Set
    case "Default"
        out = [0,0.85,0.929,0.494,0.466,0.301,0.635;...
            0.447,0.325,0.694,0.184,0.674,0.745,0.078;...
            0.741,0.098,0.125,0.556,0.188,0.933,0.184]';
        out = out*255;
        outlier = ones(1,3)*187;
    case "Bright"
        out = [ 68,102,34,204,238,170;...
            119,204,136,187,102,51;...
            170,238,51,68,119,119]';
        out = out([1,5,3,4,2,6],:);
%         out = out([1,4,5,3,2,6],:);
        outlier = ones(1,3)*187;
    case "HighCon"
        out = [ 221,187,0,0;...
            170,85,68,0;...
            51,102,136,0]';
        out = out([3,1,2],:);
        outlier = ones(1,3)*187;
    case "Vib"
        out = [ 0,51,0,238,204,238;...
            119,187,153,119,51,51;...
            187,238,136,51,17,119]';
        out = out([4,1,2,6,5,3],:);
        outlier = ones(1,3)*187;
    case "Muted"
        out = [ 51,136,68,17,153,221,204,136,170;...
            34,204,170,119,153,204,102,34,68;...
            136,238,153,51,51,119,119,85,153]';
        out = out([7,1,6,4,2,8,3,5,9],:);
        outlier = ones(1,3)*221;
    case "MidCon"
        out = [ 238,238,102,153,153,0,0;...
            204,153,153,119,68,68,0;...
            102,170,204,0,85,136,0]';
        out = out([2,5,1,4,3,6],:);
        outlier = ones(1,3)*221;
    case "Colorblind"
        out = [215,253,171,44;...
                25,174,217,123;...
                28,97,233,182]';
        out(3:4,:) = out(3:4,:)*0.9;
        outlier = ones(1,3)*187;
    case "Light"
        error('Not Implemented yet as I was lazy copying numbers')
end
end

function [out,outlier] = getDivScheme(Set)
switch Set
    case "Sunset"
        out = [ 54,74,110,152,194,234,254,253,246,221,165;...
            75,123,166,202,228,236,218,179,126,61,0;...
            154,183,205,225,239,204,139,102,75,45,38]';
        outlier = ones(1,3)*187;
    case "BuRd"
        out = [ 33,67,146,209,247,253,244,214,178;...
            102,147,197,229,247,219,165,96,24;...
            172,195,222,240,247,199,130,77,43]';
        outlier = [255,238,153];
    case "PRGn"
        outlier = [255,238,153];
        error('Not Implemented yet as I was lazy copying numbers')
end
end

function [out,outlier] = getSeqScheme(Set)
switch Set
    case "YlOrBr"
        out = [ 255,255,254,254,251,236,204,153,102;...
            255,247,227,196,154,112,76,52,37;...
            229,188,145,79,41,20,2,4,6]';
        outlier = ones(1,3)*136;
    case "Iridescent"
        out = [ 254,252,245,234,221,208,194,181,168,155,141,129,123,126,136,147,155,157,154,144,128,104,70;...
            251,247,243,240,236,231,227,221,216,210,203,196,188,178,165,152,138,125,112,99,87,73,53;...
            233,213,193,181,191,202,210,216,220,225,228,231,231,228,221,210,196,178,158,136,112,87,58]';
        outlier = ones(1,3)*153;
    case "Rainbow"
        error('Not Implemented yet as I was lazy copying numbers')
end
end


function SetVaildation(Set,Type)
switch Type
    case "qual"
        mustBeMember(Set,["Default","Bright","HighCon","Vib","Muted","MidCon","Light","Colorblind"]);
    case "div"
        mustBeMember(Set,["Sunset","BuRd","PRGn"]);
    case "seq"
        mustBeMember(Set,["YlOrBr","Iridescent","Rainbow"]);
end
end

