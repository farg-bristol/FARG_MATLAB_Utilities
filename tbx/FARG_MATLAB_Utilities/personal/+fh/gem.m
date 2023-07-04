function [v,fwt_rot_m] = gem(fold,u,root_aoa,beta,flare,sweep,dihedral,hinge_setting_angle)
    if ~exist('hinge_setting_angle','var')
        hinge_setting_angle = 0;
    end
    wing_rot_m = fh.roty(root_aoa)*fh.rotz(beta)*fh.rotx(dihedral);
    hinge_rot_m = wing_rot_m*...
        fh.rotz(-flare)*...
        fh.roty(hinge_setting_angle);
    v = zeros(3,size(fold,2));
    for i = 1:size(fold,2)
        fwt_rot_m = hinge_rot_m*...
        fh.rotx(fold(i))*...
        fh.roty(-hinge_setting_angle)*...
        fh.rotz(flare-sweep);
        v(:,i) = fwt_rot_m'*[u;0;0];
    end
end

