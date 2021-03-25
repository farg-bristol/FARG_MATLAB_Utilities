function [q] = rotationMatrixToQuat(A)
% Calculates the 4x1 quaternion from a 3x3 rotation matrix

m00 = A(1,1);
m10 = A(2,1);
m20 = A(3,1);

m01 = A(1,2);
m11 = A(2,2);
m21 = A(3,2);

m02 = A(1,3);
m12 = A(2,3);
m22 = A(3,3);

tr = m00 + m11 + m22;

if tr > 0
  S = sqrt(tr+1.0) * 2; % S=4*qw 
  qw = 0.25 * S;
  qx = (m21 - m12) / S;
  qy = (m02 - m20) / S; 
  qz = (m10 - m01) / S; 
elseif (m00 > m11)&&(m00 > m22)
  S = sqrt(1.0 + m00 - m11 - m22) * 2; % S=4*qx 
  qw = (m21 - m12) / S;
  qx = 0.25 * S;
  qy = (m01 + m10) / S; 
  qz = (m02 + m20) / S; 
elseif m11 > m22
  S = sqrt(1.0 + m11 - m00 - m22) * 2; % S=4*qy
  qw = (m02 - m20) / S;
  qx = (m01 + m10) / S; 
  qy = 0.25 * S;
  qz = (m12 + m21) / S; 
else 
  S = sqrt(1.0 + m22 - m00 - m11) * 2; % S=4*qz
  qw = (m10 - m01) / S;
  qx = (m02 + m20) / S;
  qy = (m12 + m21) / S;
  qz = 0.25 * S;
end

q = [qw; qx; qy; qz];


end