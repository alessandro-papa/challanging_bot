classdef CGeometricNearestMap < handle
    properties
        mNodeList
        mYList
        mDistanceFunc
    end
    
    methods
        %% Constructor
        function obj = CGeometricNearestMap(root, distance_func)
            obj.mNodeList     = root;
            obj.mYList        = root.mY';
            obj.mDistanceFunc = distance_func;
        end
        %% Add Node
        function addNode(obj, node)
            obj.mNodeList(end+1,1) = node;
            obj.mYList(end+1, :)   = node.mY';
        end
        %% Get Nearest
        function node = getNearest(obj, y)
            idx = knnsearch(obj.mYList, y',...
                            'K', 1,...
                            'Distance',...
                            @(x, Y)obj.mDistanceFunc(x, Y)); 
            node = obj.mNodeList(idx,1);
        end
    end
end

