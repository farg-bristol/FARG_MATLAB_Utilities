function scale_x_pos(ax,factor)
%SCALE_Y_AXIS scales the y axis ofaxis object ax by a 'factor'
% good for making x labels fit on the plot...  
pos = ax.Position;
ax.Position = [pos(1)+factor*pos(3),pos(2),(1-factor)*pos(3),pos(4)];
end

