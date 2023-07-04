function data = mode_tracking(data,opts)
arguments
    data
    opts.Mode {mustBeText} = 'MODE';
    opts.XAxis {mustBeText} = 'V'; 
    opts.NModes double = nan;
    opts.Switch = {};
    opts.Method (1,:) char {mustBeMember(opts.Method,{'cmplx','damping','modeshape','both'})} = 'cmplx'; 
    opts.XSwitchOn (:,2) double = [-inf inf];
end
%MODE_TRACKING corrects the modes numbers in flutter data
%   In the flutter data 'data' the function sweeps through each value of
%   'XAxis' and tracks which modes line up with the previous modes by
%   matching either:
%       -   'cmplx': by calculating the the closest pole from the previous
%       velocity to the next (in the complex plane)
%       -   'modeshape': by calculating the the closest mode shape from the
%       previous velocity to the next
%   INPUTS:
%       data - a data structure with the following fields
%               - <Mode>: the mode number of each mode
%               - <XAxis>: the variable to track modes across
%               - EigenVector: a column vector of the eigen vector
%       modes - number of modes to check
%   OPTIONAL PARAMETERS:
%       Mode - fieldname to specify mode number (default MODE)
%       XAxis - fieldname to track modes across (default V)
%       NModes - number of modes to track, if empty will track all modes (default [])
%       Switch: a cell array of x location to manually switch the
%               modes, of the following format
%               {{<XAxisValue>,[new_mode_order]},}, where new_mode_order is
%               a list with the numbers 1->Modes in the new order
%       Method - either 'cmplx' or 'modeshape' as described before
%   OUTPUTS:
%       data - the original data structre with the mode numbers corrected
% deal with input parameters

v_switch = cellfun(@(x)x{1},opts.Switch);

% find all unique velocities
Xi = sort(unique([data.(opts.XAxis)]));

if isnan(opts.NModes) || isempty(opts.NModes)
    NModes = max([data.(opts.Mode)]);
else
    NModes = opts.NModes;
end

% setup structure to record how mode numbers change (row n will show how
% the original mode n changes across all velocties)
mode_track = zeros(NModes,length(Xi));
[~,mode_track(:,1)] = sort(sqrt(abs(extract_complex(data([data.(opts.XAxis)]==Xi(1)),1:NModes,opts.Mode))));
% mode_track(:,1) = 1:NModes;
for v_i = 2:length(Xi)
    
    % check if we are manual switch modes
    idx = find(v_switch==Xi(v_i),1);
    if ~isempty(idx)
        M_f = opts.Switch{idx}{2};
        mode_track(:,v_i) = mode_track(M_f,v_i-1);
        continue
    end
    % check if switching is on here
    onFlag = false(size(opts.XSwitchOn,1),1);
    for i = 1:size(opts.XSwitchOn,1)
        if Xi(v_i) <= opts.XSwitchOn(i,2) && Xi(v_i) >= opts.XSwitchOn(i,1)
            onFlag(i) = true;
        end
    end
    if ~any(onFlag)
        mode_track(:,v_i) = mode_track(:,v_i-1);
        continue;
    end
    %do switching
    switch opts.Method
        case {'cmplx','damping'}
            % get frequency and damping data for this and previous velocity
            [last] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i-1)),...
                mode_track(:,v_i-1),opts.Mode);
            h = 0;
            acc = 0;
            v = 0;
            if v_i == 3
                [last2] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i-2)),...
                    mode_track(:,v_i-2),opts.Mode);
                h = Xi(v_i-1)-Xi(v_i-2);
                v = (last-last2)./h;
            elseif v_i > 3
                [last2] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i-2)),...
                    mode_track(:,v_i-2),opts.Mode);
                [last3] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i-3)),...
                    mode_track(:,v_i-3),opts.Mode);
                h = Xi(v_i-1)-Xi(v_i-2);
                %                acc = (last-4/3.*last2 + 1/3.*last3)./h.^2;
                %                acc = 0;
                v = (last-last2)./h;
            end
            last = last + v.*h + 0.5*acc.*h.^2;
            [next] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i)),...
                mode_track(:,v_i-1),opts.Mode);
        case 'modeshape'
            % get frequency and damping data for this and previous epoch
            [last] = extract_vecs(data([data.(opts.XAxis)]==Xi(v_i-1)),...
                mode_track(:,v_i-1),opts.Mode);
            [next] = extract_vecs(data([data.(opts.XAxis)]==Xi(v_i)),...
                mode_track(:,v_i-1),opts.Mode);
            zero_idx = vecnorm(last) == 0 | vecnorm(next) == 0;
            last(:,zero_idx) = 1/size(last,1);
            next(:,zero_idx) = 1/size(last,1);
        case 'combine'
            % get frequency and damping data for this and previous epoch
            [last] = extract_vecs(data([data.(opts.XAxis)]==Xi(v_i-1)),...
                mode_track(:,v_i-1),opts.Mode);
            [next] = extract_vecs(data([data.(opts.XAxis)]==Xi(v_i)),...
                mode_track(:,v_i-1),opts.Mode);
            zero_idx = vecnorm(last) == 0 | vecnorm(next) == 0;
            last(:,zero_idx) = 1/size(last,1);
            next(:,zero_idx) = 1/size(last,1);
            [last_cmplx] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i-1)),...
                mode_track(:,v_i-1),opts.Mode);
            [next_cmplx] = extract_complex(data([data.(opts.XAxis)]==Xi(v_i)),...
                mode_track(:,v_i-1),opts.Mode);
            last = [last;abs(last_cmplx)*500;angle(last_cmplx)*500];
            next = [next;abs(next_cmplx)*500;angle(next_cmplx)*500];
        otherwise
            error('Unkown Method - Method "%s" is unknown, it must be either "cmplx" or "modeshape"')
    end
    if strcmp(opts.Method,'damping')
        last = angle(last);
        next = angle(next);
    end
    M_f = distance_matrix(last,next);
    [~,idx] = max(M_f);
    mode_track(:,v_i) = mode_track(idx,v_i-1);
end

% work through data structure and replace mode numbers accordingly
for v_i = 2:length(Xi)
    tmp_idx = [data.(opts.XAxis)]==Xi(v_i);
    mode_idx = zeros(1,NModes);
    for i = 1:NModes
        mode_idx(i) = find(tmp_idx & [data.(opts.Mode)]==i,1);
    end
    for i = 1:NModes
        data(mode_idx(mode_track(i,v_i))).(opts.Mode) = i;
    end
end
end

function M_i = distance_matrix(last,next)
N = size(last,2);
M = zeros(N);
for i = 1:N
    for j = 1:N
        M(i,j) = abs(dot(last(:,i),next(:,j)));
    end
end
M_i = zeros(N);
for i = 1:N
    [val,max_i] = max(M);
    [~,max_j] = max(val);
    max_i = max_i(max_j);
    M_i(max_i,max_j) = 1;
    M(max_i,:) = 0;
    M(:,max_j) = 0;
end
end

function [x] = extract_complex(data,modes,ModeField)
x = zeros(1,length(modes));
for i = 1:length(modes)
    idx = find([data.(ModeField)]==modes(i),1);
    x(i) = data(idx).CMPLX;
end
end

function [x] = extract_vecs(data,NModes,ModeField)
x = [];
for i = 1:length(NModes)
    idx = find([data.(ModeField)]==NModes(i),1);
    if ~isempty(data(idx).EigenVector(:))
        vec = data(idx).EigenVector(:);
        x(:,i) = vec./norm(vec);
    else
        x(1:size(x,1),i) = 0;
    end
end
end



