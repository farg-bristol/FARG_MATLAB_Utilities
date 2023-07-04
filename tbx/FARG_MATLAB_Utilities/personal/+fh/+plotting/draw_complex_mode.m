function [x] = draw_complex_mode(vec,ang)
%DRAW_COMPLEX_MODE Summary of this function goes here
%   Detailed explanation goes here
x = abs(vec).*cos(angle(vec)+deg2rad(ang));
end

