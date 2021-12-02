function save(filename)
cp = campos;
ct = camtarget;
cu = camup;
cv = camva;
f = gcf;
fp = f.Position;
if ~exist('filename','var')
    filename = 'cam_pos.mat';
end
save(filename,'cp','ct','cu','cv','fp')
end