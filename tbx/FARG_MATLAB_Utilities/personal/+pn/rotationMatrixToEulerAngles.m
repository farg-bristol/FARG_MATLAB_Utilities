function [rot1,rot2,rot3] = rotationMatrixToEulerAngles(A03,rotSeq)
% Retuns the Euler angles from the 3x3 rotation transformation matrix used 
% to transform a vector in a local coordinate frame (V3) to the 
% original/global coordinate frame (V0):
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
%
% For more information refer to NASA Document ID 19770024290
% (https://ntrs.nasa.gov/citations/19770024290)
%
% - Punsara Navaratna, Univeristy of Bristol, 17/03/2021

switch rotSeq
    
    case 'ZYX' % NASA method, rotation sequence: ZYX
        
        rot1 = atan(A03(2,1)/A03(1,1));
        rot2 = atan(-A03(3,1)/(sqrt(1-(A03(3,1))^2)));
        rot3 = atan(A03(3,2)/A03(3,3));

        
    case 'XYZ' % NASA method, rotation sequence: XYZ
        
        rot1 = atan(-A03(2,3)/A03(3,3));
        rot2 = atan(A03(1,3)/(sqrt(1-(A03(1,3))^2)));
        rot3 = atan(-A03(1,2)/A03(1,1));
        
    case 'ZXY' % NASA method, rotation sequence: ZXY
        
        rot1 = atan(-A03(1,2)/A03(2,2));
        rot2 = atan(A03(3,2)/(sqrt(1-(A03(3,2))^2)));
        rot3 = atan(-A03(3,1)/A03(3,3));
        
    case 'ZXZ' % NASA method, rotation sequence: ZXZ
        
        rot1 = atan(A03(1,3)/-A03(2,3));
        rot2 = atan((sqrt(1-(A03(3,3))^2))/A03(3,3));
        rot3 = atan(A03(3,1)/A03(3,2));
        
    case 'Howcroft'
        
        rot1 = -atan(-A03(1,2)/A03(2,2)); % psi
        rot2 = atan(A03(3,2)/(sqrt(1-(A03(3,2))^2))); % theta
        rot3 = atan(-A03(3,1)/A03(3,3)); % phi
        
end

end

