function rot_b =  rotateAbout(a, b, theta)
% Rotate vector a about vector b by theta radians.
% Thanks user MNKY at http://math.stackexchange.com/a/1432182/81266
[par,perp] = xProjectV(a, b);
if norm(perp)==0 %they are colinear so just return the veector
    rot_b = a;
else
    w = cross(b, perp);
    w = w/norm(w);
    rot_b = (par + perp * cosd(theta) + norm(perp) * w * sind(theta));
end
end


function [par,perp] =  xProjectV(x, v)
    % Project x onto v, returning parallel and perpendicular components
    par = dot(x, v) / dot(v, v) * v;
    perp = x - par;
end
