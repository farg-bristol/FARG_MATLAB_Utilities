function scale_y_pos(ax,factor)
%SCALE_Y_AXIS scales the y axis ofaxis object ax by a 'factor'
% good for making x labels fit on the plot...  
pos = ax.Position;
ax.Position = [pos(1),pos(2)+factor*pos(4),pos(3),(1-factor)*pos(4)];
end

