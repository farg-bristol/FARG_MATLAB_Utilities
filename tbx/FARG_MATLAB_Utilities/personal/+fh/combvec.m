function out = combvec(varargin)
%COMBVEC Summary of this function goes here
%   Detailed explanation goes here
if nargin == 2
    A = varargin{1};
    B = varargin{2};
    out = zeros(length(A)*length(B),2);
    for i = 1:length(A)
        for j = 1:length(B)
            idx = (i-1)*length(B)+j;
            out(idx,:) = [A(i),B(j)];
        end
    end
else
   A = fh.combvec(varargin{1:end-1});
   Na = size(A,1);
   B = varargin{end};
   Nb = length(B);
   out = [repmat(A,Nb,1),zeros(Nb*Na,1)];
   idx = 1;
   for i = 1:Nb
       out(idx:idx+Na-1,end) = B(i);
       idx = idx + Na;
   end
end
end

