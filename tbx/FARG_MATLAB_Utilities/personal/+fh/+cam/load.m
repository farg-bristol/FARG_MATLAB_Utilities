function load(filename)
if ~exist('filename','var')
    filename = 'cam_pos.mat';
end
load(filename,'cp','ct','cu','cv','fp')
campos(cp);
camtarget(ct);
camup(cu);
camva(cv);
f = gcf;
f.Position = fp;
end