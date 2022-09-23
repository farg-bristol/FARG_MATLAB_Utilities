function [v,fwt_rot_m] = gem(fold,u,root_aoa,beta,flare,sweep,dihedral,hinge_setting_angle)
    if ~exist('hinge_setting_angle','var')
        hinge_setting_angle = 0;
    end
    wing_rot_m = fh.roty(root_aoa)*fh.rotz(beta)*fh.rotx(dihedral);
    hinge_rot_m = wing_rot_m*...
        fh.rotz(-flare)*...
        fh.roty(hinge_setting_angle);
    fwt_rot_m = hinge_rot_m*...
        fh.rotx(fold)*...
        fh.roty(-hinge_setting_angle)*...
        fh.rotz(flare-sweep);
    v = [u 0 0]*fwt_rot_m;
end

