function [points] = octagon_nodes(height,width,opts)
arguments
    height
    width
    opts.x_fillet = 0;
    opts.y_fillet = 0;
    opts.origin = [0,0];
end
%OCTAGON_NODES Summary of this function goes here
%   Detailed explanation goes here

x_fillet = opts.x_fillet;
y_fillet = opts.y_fillet;
points = zeros(8,2);
points(1,:) = [0,y_fillet];
points(2,:) = [0,height-y_fillet];
points(3,:) = [x_fillet,height];
points(4,:) = [width-x_fillet,height];
points(5,:) = [width,height-y_fillet];
points(6,:) = [width,y_fillet];
points(7,:) = [width-x_fillet,0];
points(8,:) = [x_fillet,0];
points = points + repmat(opts.origin(:)',8,1);
end
