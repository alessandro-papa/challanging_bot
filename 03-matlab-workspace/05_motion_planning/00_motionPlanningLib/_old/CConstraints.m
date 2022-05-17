classdef CConstraints < handle
    %CCONSTRAINTS Class holding state, configurationj, and input 
    % constraints as member variables.
    
    properties
        mYMax
        mYMin
        mXMax
        mXMin
        mUMax
        mUMin
    end
    
    methods
        function obj = CConstraints()
            % Default constructor with default constraints
            obj.mXMax = [deg2rad(90); 4*pi; 3.5; 4; 300];
            obj.mXMin = -[deg2rad(90); 4*pi; 0.5; 4; 300];
            obj.mYMax = obj.mXMax([1,3],:);
            obj.mYMin = obj.mXMin([1,3],:);
            obj.mUMax = [1.5; 1];
            obj.mUMin = -obj.mUMax;
        end
    end
end

