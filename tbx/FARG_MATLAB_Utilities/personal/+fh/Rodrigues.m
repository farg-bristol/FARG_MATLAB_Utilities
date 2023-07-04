function A = Rodrigues(omega)
%RODRIGUES Reurns the rotation matix assiated with the vector omega
%   omega is a vector whos direction refines the axis of rotation and who
%   magnitude defines the magnitude of rotation (in radians)
angle = norm(omega);
if angle == 0
    A = eye(3);
else
    n = omega./angle;
    A = eye(3)+ fh.Wedge(n)*sin(angle) + fh.Wedge(n)*fh.Wedge(n)*(1-cos(angle));
end
end

