function [A03,q] = rotationTransform(rot1,rot2,rot3,rotSeq)
% Calculates the rotation transformation matrix to transform a vector in a
% local coordinate frame (V3) to the original/global coordinate frame 
% (V0):
%
%   V0 = A03 * V3
%
%   - Input angles (rotX) are in radians
%   - Rotation sequences from original coordinate frame (0) to local 
%     coordinate frame (3) (rotSeq):
%       'ZYX'
%       'XYZ'
%       'ZXY'
%       'ZXZ'
%       'Howcroft'
%       'vector'
%
% Also outputs the 4x1 quaternion (q)
%
% For more information refer to NASA Document ID 19770024290
% (https://ntrs.nasa.gov/citations/19770024290)
%
% - Punsara Navaratna, Univeristy of Bristol, 17/03/2021

switch rotSeq
    
    case 'ZYX' % NASA method, rotation sequence: ZYX (conventional)
        
        % Quaternions
        C1 = cos(rot1/2);
        C2 = cos(rot2/2);
        C3 = cos(rot3/2);
        S1 = sin(rot1/2);
        S2 = sin(rot2/2);
        S3 = sin(rot3/2);
        
        q1 = +S1*S2*S3 + C1*C2*C3;
        q2 = -S1*S2*C3 + S3*C1*C2;
        q3 = +S1*S3*C2 + S2*C1*C3;
        q4 = +S1*C2*C3 - S2*S3*C1;
        
        % Rotation matrix
        M11 = cos(rot1)*cos(rot2);
        M21 = sin(rot1)*cos(rot2);
        M31 = -sin(rot2);

        M12 = cos(rot1)*sin(rot2)*sin(rot3)-sin(rot1)*cos(rot3);
        M22 = sin(rot1)*sin(rot2)*sin(rot3)+cos(rot1)*cos(rot3);
        M32 = cos(rot2)*sin(rot3);

        M13 = cos(rot1)*sin(rot2)*cos(rot3)+sin(rot1)*sin(rot3);
        M23 = sin(rot1)*sin(rot2)*cos(rot3)-cos(rot1)*sin(rot3);
        M33 = cos(rot2)*cos(rot3);

        A03 = [     M11     M12     M13
                    M21     M22     M23
                    M31     M32     M33     ];


        % Cook method (alternative) (pg.20)
        C1 = cos(rot1);
        C2 = cos(rot2);
        C3 = cos(rot3);
        S1 = sin(rot1);
        S2 = sin(rot2);
        S3 = sin(rot3);

        D = [   C2*C1               C2*S1               -S2
                S3*S2*C1-C3*S1      S3*S2*S1+C3*C1      S3*C2
                C3*S2*C1+S3*S1      C3*S2*S1-S3*C1      C3*C2   ];

        A03_alt = transpose(D);
               
        
    case 'XYZ' % NASA method, rotation sequence: XYZ

        % Quaternions
        C1 = cos(rot1/2);
        C2 = cos(rot2/2);
        C3 = cos(rot3/2);
        S1 = sin(rot1/2);
        S2 = sin(rot2/2);
        S3 = sin(rot3/2);

        q1 = -S1*S2*S3 + C1*C2*C3;
        q2 = +S1*C2*C3 + S2*S3*C1;
        q3 = -S1*S3*C2 + S2*C1*C3;
        q4 = +S1*S2*C3 + S3*C1*C2;

        M11 = cos(rot2)*cos(rot3);
        M21 = sin(rot1)*sin(rot2)*cos(rot3)+cos(rot1)*sin(rot3);
        M31 = -cos(rot1)*sin(rot2)*cos(rot3)+sin(rot1)*sin(rot3);

        M12 = -cos(rot2)*sin(rot3);
        M22 = -sin(rot1)*sin(rot2)*sin(rot3)+cos(rot1)*cos(rot3);
        M32 = cos(rot1)*sin(rot2)*sin(rot3)+sin(rot1)*cos(rot3);

        M13 = sin(rot2);
        M23 = -sin(rot1)*cos(rot2);
        M33 = cos(rot1)*cos(rot2);

        A03 = [     M11     M12     M13
                    M21     M22     M23
                    M31     M32     M33     ];
            
                
    case 'ZXY' % NASA method, rotation sequence: ZXY

        % Quaternions
        C1 = cos(rot1/2);
        C2 = cos(rot2/2);
        C3 = cos(rot3/2);
        S1 = sin(rot1/2);
        S2 = sin(rot2/2);
        S3 = sin(rot3/2);

        q1 = -S1*S2*S3 + C1*C2*C3;
        q2 = -S1*S3*C2 + S2*C1*C3;
        q3 = +S1*S2*C3 + S3*C1*C2;
        q4 = +S1*C2*C3 + S2*S3*C1;

        M11 = -sin(rot1)*sin(rot2)*sin(rot3)+cos(rot1)*cos(rot3);
        M21 = cos(rot1)*sin(rot2)*sin(rot3)+sin(rot1)*cos(rot3);
        M31 = -cos(rot2)*sin(rot3);

        M12 = -sin(rot1)*cos(rot2);
        M22 = cos(rot1)*cos(rot2);
        M32 = sin(rot2);

        M13 = sin(rot1)*sin(rot2)*cos(rot3)+cos(rot1)*sin(rot3);
        M23 = -cos(rot1)*sin(rot2)*cos(rot3)+sin(rot1)*sin(rot3);
        M33 = cos(rot2)*cos(rot3);

        A03 = [     M11     M12     M13
                    M21     M22     M23
                    M31     M32     M33     ];
                
    case 'ZXZ' % NASA method, rotation sequence: ZXZ

        % Quaternions
        q1 = +cos(rot2/2)*cos((rot1+rot2)/2);
        q2 = +sin(rot2/2)*cos((rot1-rot3)/2);
        q3 = +sin(rot2/2)*sin((rot1-rot3)/2);
        q4 = +cos(rot2/2)*sin((rot1+rot3)/2);

        M11 = -sin(rot1)*cos(rot2)*sin(rot3)+cos(rot1)*cos(rot3);
        M21 = +cos(rot1)*cos(rot2)*sin(rot3)+sin(rot1)*cos(rot3);
        M31 = +sin(rot1)*sin(rot3);

        M12 = -sin(rot1)*cos(rot2)*cos(rot3)-cos(rot1)*cos(rot3);
        M22 = +cos(rot1)*cos(rot2)*cos(rot3)-sin(rot1)*sin(rot3);
        M32 = +sin(rot2)*cos(rot3);

        M13 = +sin(rot1)*sin(rot2);
        M23 = -cos(rot1)*sin(rot2);
        M33 = cos(rot2);

        A03 = [     M11     M12     M13
                    M21     M22     M23
                    M31     M32     M33     ];
            
            
    case 'Howcroft'
        
        % NOTE: the first rotation (psi) in Howcroft's method is the
        % opposite of the right hand rule. Therefore this rotation sequence is the
        % same as '312' with the first rotation being negative.
        
        psi = rot1;
        theta = rot2;
        phi = rot3;
        
        M11 = cos(psi)*cos(phi)+sin(theta)*sin(psi)*sin(phi);
        M21 = -sin(psi)*cos(phi)+sin(theta)*cos(psi)*sin(phi);
        M31 = -cos(theta)*sin(phi);

        M12 = cos(theta)*sin(psi);
        M22 = cos(theta)*cos(psi);
        M32 = sin(theta);

        M13 = cos(psi)*sin(phi)-sin(theta)*sin(psi)*cos(phi);
        M23 = -sin(psi)*sin(phi)-sin(theta)*cos(psi)*cos(phi);
        M33 = cos(theta)*cos(phi);

        A03 = [     M11     M12     M13
                    M21     M22     M23
                    M31     M32     M33     ];
                
        q1 = 0;
        q2 = 0;
        q3 = 0;
        q4 = 0;
        
    case 'Nastran'
        
        % Space-fixed rotations in XYZ sequence specify all the rotations 
        % about the global fixed coordinate axes (not intermediate axes)
        
        R1 = rot1;
        R2 = rot2;
        R3 = rot3;
        
        A01 = [ 1   0           0
                0   cos(R1)     -sin(R1)
                0   sin(R1)     cos(R1) ];
        A0prime0 = [    cos(R2)     0       sin(R2)
                        0           1       0
                        -sin(R2)    0       cos(R2)     ];
        A0primeprime0 = [   cos(R3)     -sin(R3)    0
                            sin(R3)     cos(R3)     0
                            0           0           1   ];
        A03 = A0primeprime0*A0prime0*A01;
        
        q1 = 0;
        q2 = 0;
        q3 = 0;
        q4 = 0;
        
    case 'vector' % rotation vector to transformation matrix
        
%         theta = sqrt(rot1^2 + rot2^2 + rot3^2);
%         rotVector = [rot1, rot2, rot3]./theta;
%         quat1 = cos(theta/2);
%         quat2 = rotVector(1)*sin(theta/2);
%         quat3 = rotVector(2)*sin(theta/2);
%         quat4 = rotVector(3)*sin(theta/2);
        
        rotVector = [rot1, rot2, rot3];
        quat = quaternion(rotVector,'rotvec');
        euler(quat,'XYZ','frame');
        [quat1,quat2,quat3,quat4] = parts(quat);
        
        q0 = quat1;
        q1 = quat2;
        q2 = quat3;
        q3 = quat4;

        A03_q1 = [   1-2*q2^2-2*q3^2     2*(q1*q2-q0*q3)  	2*(q1*q3+q0*q2)
                    2*(q1*q2+q0*q3)     1-2*q1^2-2*q3^2    	2*(q2*q3-q0*q1)
                    2*(q1*q3-q0*q2)     2*(q2*q3+q0*q1)     1-2*q1^2-2*q2^2     ];
                
        A03 = A03_q1;
        
        q1 = quat1;
        q2 = quat2;
        q3 = quat3;
        q4 = quat4;
            
end
 
%% EXTRAS

% Transformation matrix using quaternions
quat_0_to_1 = [q1;q2;q3;q4];

q0 = quat_0_to_1(1);
q1 = quat_0_to_1(2);
q2 = quat_0_to_1(3);
q3 = quat_0_to_1(4);

A03_q1 = [   1-2*q2^2-2*q3^2     2*(q1*q2-q0*q3)  	2*(q1*q3+q0*q2)
            2*(q1*q2+q0*q3)     1-2*q1^2-2*q3^2    	2*(q2*q3-q0*q1)
            2*(q1*q3-q0*q2)     2*(q2*q3+q0*q1)     1-2*q1^2-2*q2^2     ];
        
        
% Shabana method (alternative method using quaternions)
qa0 = q0;
qa1 = q1;
qa2 = q2;
qa3 = q3;

Ea = [  -qa1     qa0      -qa3     qa2
        -qa2     qa3      qa0      -qa1
        -qa3     -qa2     qa1      qa0  ];

E_dasha = [     -qa1     qa0      qa3      -qa2
                -qa2     -qa3     qa0      qa1
                -qa3     qa2      -qa1     qa0  ];

A03_q2 = Ea*transpose(E_dasha);

q = [q1;q2;q3;q4];



end