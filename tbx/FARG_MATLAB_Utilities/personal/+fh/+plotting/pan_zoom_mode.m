function pan_zoom_mode(fig_handle)
%PANZOOM Summary of this function goes here
%   Detailed explanation goes here
set(fig_handle, 'WindowButtonDownFcn',    @ButtonDownCallback, ...
      'WindowScrollWheelFcn',   @WindowScrollWheelCallback, ...
      'KeyPressFcn',            @KeyPressCallback, ...
      'WindowButtonUpFcn',      @ButtonUpCallback)
end

function ButtonDownCallback(src, ~)
if strcmp(get(src, 'SelectionType'), 'normal')
% -> the left mouse button is clicked once
% enable the interactive rotation
userData = get(gca, 'UserData');
userData.ppos = get(0, 'PointerLocation');
set(gca, 'UserData', userData)
set(gcf,'WindowButtonMotionFcn',@ButtonMotionCallback)
ButtonMotionCallback(src)   
elseif strcmp(get(src, 'SelectionType'), 'extend')
% -> the left mouse button is clicked once
% enable the interactive rotation
userData = get(gca, 'UserData');
userData.ppos = get(0, 'PointerLocation');
set(gca, 'UserData', userData)
set(gcf,'WindowButtonMotionFcn',@ButtonDragCallback)
ButtonDragCallback(src)
elseif strcmp(get(src, 'SelectionType'), 'open')
% -> the left mouse button is double-clicked
% create a datatip
cursorMode = datacursormode(src);
hDatatip = cursorMode.createDatatip(get(gca, 'Children'));

% move the datatip to the position
ax_ppos = get(gca, 'CurrentPoint');
ax_ppos = ax_ppos([1, 3, 5]);  
% uncomment the next line for Matlab R2014a and earlier
% set(get(hDatatip, 'DataCursor'), 'DataIndex', index, 'TargetPoint', ax_ppos)
set(hDatatip, 'Position', ax_ppos)
cursorMode.updateDataCursors    
end
end
function ButtonMotionCallback(~, ~)
% check if the user data exist
if isempty(get(gca, 'UserData'))
    return
end
% camera rotation
userData = get(gca, 'UserData');
old_ppos = userData.ppos;
new_ppos = get(0, 'PointerLocation');


userData.ppos = new_ppos;
set(gca, 'UserData', userData)

dx = (new_ppos(1) - old_ppos(1))*0.25;
dy = (new_ppos(2) - old_ppos(2))*0.25;
camorbit(gca, -dx, -dy)
end

function ButtonDragCallback(~, ~)
% check if the user data exist
if isempty(get(gca, 'UserData'))
    return
end
% camera rotation
userData = get(gca, 'UserData');
old_ppos = userData.ppos;
new_ppos = get(0, 'PointerLocation');

userData = get(gca, 'UserData');
userData.ppos = new_ppos;
set(gca, 'UserData', userData)


dx = (new_ppos(1) - old_ppos(1))*0.01;
dy = (new_ppos(2) - old_ppos(2))*0.01;
camdolly(gca, -dx, -dy, 0)
end

function WindowScrollWheelCallback(~, eventdata)
% set the zoom facor
if eventdata.VerticalScrollCount < 0
    % increase the magnification
    zoom_factor = 1.05;
else 
    % decrease the magnification
    zoom_factor = 0.95;
end
% camera zoom
camzoom(zoom_factor)
end
function KeyPressCallback(~, eventdata)
% check which key is pressed
if strcmp(eventdata.Key, 'uparrow')
    dx = 0; dy = 0.05;
    camdolly(gca, dx, dy, 0)
elseif strcmp(eventdata.Key, 'downarrow')
    dx = 0; dy = -0.05;
    camdolly(gca, dx, dy, 0)
elseif strcmp(eventdata.Key, 'leftarrow')
    dx = -0.05; dy = 0;
    camdolly(gca, dx, dy, 0)
elseif strcmp(eventdata.Key, 'rightarrow')
    dx = 0.05; dy = 0;
    camdolly(gca, dx, dy, 0)
end

% once again check which key is pressed
if strcmp(eventdata.Key, 'space')
    % restore the original axes and exit the explorer
    userData = get(gcf, 'UserData');
    userData.obj.StopAnimation = true;
end
end
function ButtonUpCallback(~, ~)
% clear the pointer position
    set(gca, 'UserData', [])
end
function cbToggleVisible(~, evt)
    %cbToggleVisible Toggles the visibility of a all graphic objects with 
    % the same tag as the one clicked on in the legend.
    if isprop(evt.Peer, 'Tag')
        objs = findobj('Tag',evt.Peer.Tag);
        for i = 1:length(objs)
            if ~isprop(objs(i), 'Visible')
                continue
            else
                switch objs(i).Visible
                    case 'on'
                        objs(i).Visible = 'off';
                    case 'off'
                        objs(i).Visible = 'on';
                end
            end
        end
    elseif isprop(evt.Peer, 'Visible')
        switch evt.Peer.Visible
            case 'on'
                evt.Peer.Visible = 'off';
            case 'off'
                evt.Peer.Visible = 'on';
        end
    end    
end

