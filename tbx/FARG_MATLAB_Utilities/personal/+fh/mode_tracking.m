function data = mode_tracking(data,varargin)
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
%       manual_switch: a cell array of x location to manually switch the
%               modes, of the following format
%               {{<XAxisValue>,[new_mode_order]},}, where new_mode_order is
%               a list with the numbers 1->Modes in the new order
%       Method - either 'cmplx' or 'modeshape' as described before
%   OUTPUTS:
%       data - the original data structre with the mode numbers corrected
% deal with input parameters
p = inputParser();
p.addParameter('Mode','MODE',@ischar);
p.addParameter('XAxis','V',@ischar);
p.addParameter('NModes',[],@isnumeric);
p.addParameter('manual_switch',{});
p.addParameter('Method','cmplx');
p.parse(varargin{:})

v_switch = cellfun(@(x)x{1},p.Results.manual_switch);

% find all unique velocities
Xi = sort(unique([data.(p.Results.XAxis)]));

if isempty(p.Results.NModes)
    NModes = max([data.(p.Results.Mode)]);
else
    NModes = p.Results.NModes;
end

% setup structure to record how mode numbers change (row n will show how
% the original mode n changes across all velocties)
mode_track = zeros(NModes,length(Xi));
mode_track(:,1) = 1:NModes;
for v_i = 2:length(Xi)
   % check if we are manual switch modes 
   idx = find(v_switch==Xi(v_i),1);
   if ~isempty(idx)
       M_f = p.Results.manual_switch{idx}{2};
       mode_track(:,v_i) = mode_track(M_f,v_i-1);
       continue
   end
   
   switch p.Results.Method
       case 'cmplx'
           % get frequency and damping data for this and previous velocity
           [last] = extract_complex(data([data.(p.Results.XAxis)]==Xi(v_i-1)),...
               mode_track(:,v_i-1),p.Results.Mode);
           [next] = extract_complex(data([data.(p.Results.XAxis)]==Xi(v_i)),...
               mode_track(:,v_i-1),p.Results.Mode);
       case 'modeshape'
           % get frequency and damping data for this and previous epoch
           [last] = extract_vecs(data([data.(p.Results.XAxis)]==Xi(v_i-1)),...
               mode_track(:,v_i-1),p.Results.Mode);
           [next] = extract_vecs(data([data.(p.Results.XAxis)]==Xi(v_i)),...
               mode_track(:,v_i-1),p.Results.Mode);
       otherwise
           error('Unkown Method - Method "%s" is unknown, it must be either "cmplx" or "modeshape"')
   end
   M_f = distance_matrix(last,next);
   [~,idx] = max(M_f);
   mode_track(:,v_i) = mode_track(idx,v_i-1); 
end

% work through data structure and replace mode numbers accordingly
for v_i = 2:length(Xi)
    tmp_idx = [data.(p.Results.XAxis)]==Xi(v_i);
    mode_idx = zeros(1,NModes);
    for i = 1:NModes
        mode_idx(i) = find(tmp_idx & [data.(p.Results.Mode)]==i,1);
    end
    for i = 1:NModes
        data(mode_idx(mode_track(i,v_i))).(p.Results.Mode) = i;
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
    x = zeros(2,length(modes));
    for i = 1:length(modes)
        idx = find([data.(ModeField)]==modes(i),1);
        x(:,i) = data(idx).CMPLX;
    end
end

function [x] = extract_vecs(data,NModes,ModeField)
    x = [];
    for i = 1:length(NModes)
        idx = find([data.(ModeField)]==NModes(i),1);
        vec = data(idx).EigenVector(:);
        x(:,i) = vec./norm(vec);
    end
end



