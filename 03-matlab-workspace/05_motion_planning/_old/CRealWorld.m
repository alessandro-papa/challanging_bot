classdef CRealWorld < handle
    %CRealWorld Class for representing the TWIPR's 2D "real world"  consisting of
    %obstacles in the XZ-plain.
    
    properties
        mPitchMax
        mPitchMin
        mPositionMax
        mPositionMin
        mTWIPRPoly
        mObstacles
    end
    
    methods
        %% Constructor
        function obj = CRealWorld(pitch_max,...
                                  pitch_min,...
                                  position_max,...
                                  position_min,...
                                  twipr_polygon)
            %CRealWorld Constructor to initialize a new object.
            obj.mPitchMax    = pitch_max;
            obj.mPitchMin    = pitch_min;
            obj.mPositionMax = position_max;
            obj.mPositionMin = position_min;
            obj.mTWIPRPoly   = twipr_polygon;
            obj.mObstacles   = {};
        end
        %% Add Obstacle
        function addObstacle(obj, obs)
            obj.mObstacles{end+1,1} = obs;
        end
        %% Draw TWIPR
        function drawTWIPR(obj, pitch, position, col)
            y = [pitch; position];
            twipr = rotate(obj.mTWIPRPoly, -rad2deg(y(1,1)), [0, 0.1]);
            twipr = translate(twipr, y(2,1), 0);
            p = plot(twipr);
            p.FaceAlpha = 0.7;
            if(nargin > 3)
                p.FaceColor = col;
            end
        end
        %% Draw Real TWIPR
        function [plotObjects] = drawRealTWIPR(obj, pitch, position, col)
            y = [pitch; position];
            twipr = rotate(obj.mTWIPRPoly, -rad2deg(y(1,1)), [0, 0.1]);
            twipr = translate(twipr, y(2,1), 0);
            p = plot(twipr);
            p.FaceAlpha = 0.7;
            p.LineWidth = 1.5;

            vertices = obj.mTWIPRPoly.Vertices;
            d = max(vertices(:,1))-min(vertices(:,1)); d = d*1.2;
            w = rectangle('Position', [position-d/2, 0, d, d], 'Curvature', [1,1]);
            w.LineWidth = 1.5;
            w.FaceColor = 'white';
            if(nargin > 3)
                p.FaceColor = col;
            end
            plotObjects = {p; w};
        end
        %% Draw World
        function drawWorld(obj)
            % Draw Borders
            off  = 0.05;
            smin = obj.mPositionMin;
            smax = obj.mPositionMax;
            leftBorder  = polyshape([smin-off, smin-off, smin, smin], [0, 1, 1, 0]);
            rightBorder = polyshape([smax+off, smax+off, smax, smax], [0, 1, 1, 0]);
            ground      = polyshape([smin-off, smin-off, smax+off, smax+off],...
                                    [-off, 0, 0, -off]);
            border = [leftBorder, rightBorder, ground];
            for k = 1:3
                obs = border(1,k);
                p   = plot(obs); hold on;
                p.FaceAlpha = 0.7;
                p.FaceColor = [0.3, 0.3, 0.3];
            end
            
            % Draw Obstacles
            for k = 1:length(obj.mObstacles)
                obs = obj.mObstacles{k,1};
                p   = plot(obs); hold on;
                p.FaceAlpha = 1;
                p.FaceColor = [0.2, 0.2, 0.2];
            end
            
            % Final Configuration
            daspect([1,1,1]);
            grid on;
            xlim([smin-off/2, smax+off/2]);
            ylim([-off/2, max(obj.mTWIPRPoly.Vertices(:,2))+off]);
            xlabel('x coordinate [m]');
            ylabel('z coordinate [m]');
            title('Real World');
        end
        %% Check Configuration Collision
        function isInCollision = checkConfigurationInCollision(obj, y)
            % Construct TWIPR
            d = 0.2;
            h = 0.7;
            twipr = polyshape([-d/2, -d/2, d/2, d/2], [d/2, d/2+h, d/2+h, d/2]);
            twipr = rotate(twipr, -rad2deg(y(1,1)), [0, 0.1]);
            twipr = translate(twipr, y(2,1), 0);
            
            % Iterate Obstacles
            isInCollision = false;
            for k = 1:length(obj.mObstacles)
                obs = obj.mObstacles{k,1};
                tmp = intersect(twipr, obs);
                if(tmp.NumRegions > 0)
                    isInCollision = true;
                    break;
                end
            end
        end
    end
end

