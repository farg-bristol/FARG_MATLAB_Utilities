function rot_b =  rotateAbout(a, b, theta)
% Rotate vector a about vector b by theta radians.
% Thanks user MNKY at http://math.stackexchange.com/a/1432182/81266
[par,perp] = xProjectV(a, b);
rot_b = zeros(size(a));

vn_perp = vecnorm(perp);
idx = vn_perp~=0;
rot_b(:,~idx) = a(:,~idx);

w = cross(b(:,idx), perp(:,idx));
w = w./vecnorm(w);
rot_b(:,idx) = (par(:,idx) + perp(:,idx) .* cosd(theta) + vn_perp(idx) .* w .* sind(theta));
end


function [par,perp] =  xProjectV(x, v)
    % Project x onto v, returning parallel and perpendicular components
    par = dot(x, v) ./ dot(v, v) .* v;
    perp = x - par;
end
