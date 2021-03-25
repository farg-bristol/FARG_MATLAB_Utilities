function [A03_q1] = quatToRotationMatrix(q)
% Calculates the 3x3 rotation matrix from a 4x1 quaternion

q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

A03_q1 = [   1-2*q2^2-2*q3^2     2*(q1*q2-q0*q3)  	2*(q1*q3+q0*q2)
            2*(q1*q2+q0*q3)     1-2*q1^2-2*q3^2    	2*(q2*q3-q0*q1)
            2*(q1*q3-q0*q2)     2*(q2*q3+q0*q1)     1-2*q1^2-2*q2^2     ];


end