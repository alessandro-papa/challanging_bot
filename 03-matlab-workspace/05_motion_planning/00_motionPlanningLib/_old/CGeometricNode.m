classdef CGeometricNode < handle
    %CNODE Class for handling nodes in the search graph. A node consists of
    %a configuration, state, and action leading to this state/config.
    
    properties
        mY
        mChildren
        mParent
    end
    
    methods
        %% Constructor
        function obj = CGeometricNode(y, parent)
            obj.mY = y;
            obj.mChildren = {};
            obj.mParent   = parent;
        end
        %% Add Child
        function child = addChild(obj, y)
            child                  = CGeometricNode(y, obj);
            obj.mChildren{end+1,1} = child;
        end
        %% Draw
        function draw(obj, col)
            % Iterate all children
            for k = 1:length(obj.mChildren)
                child = obj.mChildren{k,1};
                % x/y arrays for plotting parent/child connection
                xp    = [obj.mY(2,1), child.mY(2,1)];
                yp    = [obj.mY(1,1), child.mY(1,1)];
                line(xp, yp, 'LineWidth', 1.1, 'Color', col);
                % call child
                child.draw(col);
            end
        end
    end
end

