classdef CKinodynamicNode < handle
    properties
        mX      % node configuration
        mXT     % X-trajectory to connect nodes
        mU      % U-trajectory to connect nodes
%         mUT
%         mUF
        mChildren   % children nodes
        mParent     % parent node
        mX2YFunc
    end
    
    methods
        %% Constructor
        function obj = CKinodynamicNode(x, xt,  u, parent, x2yfunc)
            obj.mX        = x;
            obj.mXT       = xt;
            obj.mU        = u;
%             obj.mUT       = u(1);
%             obj.mUF       = u(2);
            obj.mChildren = {};
            obj.mParent   = parent;
            obj.mX2YFunc  = x2yfunc;
        end
        %% Add Child
        function child = addChild(obj, x, xt, u)
            child                  = CKinodynamicNode(x, xt, u, obj, obj.mX2YFunc);
            obj.mChildren{end+1,1} = child;
        end
        %% Draw
        function draw(obj, col)
            % x/y arrays for plotting parent/child connection
            if(obj.mParent ~= -1)
                xT = [obj.mParent.mX, obj.mXT];
                l  = zeros(2, size(xT, 2));
                for n = 1:size(xT, 2)
                    l(:, n) = obj.mX2YFunc(xT(:,n));
                end
                line(l(1,:), l(2,:), 'LineWidth', 1.1, 'Color', col);
            end
            % Iterate all children
            for k = 1:length(obj.mChildren)
                child = obj.mChildren{k,1};
                % call child
                child.draw(col);
            end
        end
    end
end


