function c = redblue(n,range,opts)
%REDBLUE    Shades of red and blue color map
%   REDBLUE(n,range), returns c whichis a nx3 colour map starting at blue,
%   moving to white, then going to red. The white is centred according to
%   the range parameter which is a 1x3 array, where range(1) is the minimal
%   value of your function, range(2) is the val which should be white, and
%   range(3) is the max val of you function. On either side of white the
%   rate of change of blue or red is constant, hence if range(2) is not in
%   the middle only one side will reach either fully red or blue.
%   
%   Copyright Fintan Healy, 10/03/2022, fintan.healy@bristol.ac.uk
%
arguments
    n = size(get(gcf,'colormap'),1);
    range = [0 0.5 1];
    opts.start = [1 0 0];
    opts.centre = [1 1 1];
    opts.finish = [0 0 1];
end
range = range -range(1);
range = range./abs(range(end));

m_split = (range(2)*n);

if m_split < n-m_split
    lum_b = 1 - m_split/(n-m_split);
    lum_r = 0;
else
    lum_b = 0;
    lum_r = 1 - (n-m_split)/m_split;
end

if mod(m_split,1) ~= 0
    m_split = floor(m_split);
    n_reds = n-m_split+1;
else
    n_reds = n-m_split;
end

blues = zeros(m_split,3);
delta_blue = opts.finish + (opts.centre - opts.finish) * lum_b;

reds = zeros(n_reds,3);
delta_red = opts.centre + (opts.start - opts.centre) * (1-lum_r);

for i = 1:3
    blues(:,i) = linspace(delta_blue(i),opts.centre(i),m_split);
    tmp = linspace(opts.centre(i),delta_red(i),n_reds+1);
    reds(:,i) = tmp(2:end);
end
c = [blues;reds];
end



