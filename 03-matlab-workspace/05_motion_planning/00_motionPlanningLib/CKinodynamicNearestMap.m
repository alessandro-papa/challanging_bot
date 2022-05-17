classdef CKinodynamicNearestMap < handle
    properties
        mNodeList
        mXList
        mDistanceFunc
    end
    
    methods
        %% Constructor
        function obj = CKinodynamicNearestMap(root, distance_func)
            obj.mNodeList     = root;
            obj.mXList        = root.mX';
            obj.mDistanceFunc = distance_func;
        end
        %% Add Node
        function addNode(obj, node)
            obj.mNodeList(end+1,1) = node;
            obj.mXList(end+1, :)   = node.mX';
        end
        %% Get Nearest
        function node = getNearest(obj, x)
            idx = knnsearch(obj.mXList,x',...
                            'K', 1,...
                            'Distance',...
                            @(x, Y)obj.mDistanceFunc(x, Y)); 
            node = obj.mNodeList(idx,1);
        end
    end
end

