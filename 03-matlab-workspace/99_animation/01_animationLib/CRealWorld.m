classdef CRealWorld < handle
    %CRealWorld Class for representing the Chabo's 2D "real world"  consisting of
    %obstacles in the XZ-plain.
    
    properties
        mPitchMax
        mPitchMin
        mPositionMax
        mPositionMin
        mChaboPoly
        mObstacles
    end
    
    methods
        %% Constructor
        function obj = CRealWorld(pitch_max,...
                                  pitch_min,...
                                  position_max,...
                                  position_min,...
                                  chabo_polygon)
            %CRealWorld Constructor to initialize a new object.
            obj.mPitchMax    = pitch_max;
            obj.mPitchMin    = pitch_min;
            obj.mPositionMax = position_max;
            obj.mPositionMin = position_min;
            obj.mChaboPoly   = chabo_polygon;
            obj.mObstacles   = {};
        end
        %% Add Obstacle
        function addObstacle(obj, obs)
            obj.mObstacles{end+1,1} = obs;
        end
        %% Draw Chabo
        function drawChabo(obj, pitch, position, col)
            y = [pitch; position];
            chabo = rotate(obj.mChaboPoly, -rad2deg(y(1,1)), [0, 0.1]);
            chabo = translate(chabo, y(2,1), 0);
            p = plot(chabo);
            p.FaceAlpha = 0.7;
            if(nargin > 3)
                p.FaceColor = col;
            end
        end
        %% Draw Real Chabo
        function [plotObjects] = drawRealChabo(obj, pitch, position, col)
            y = [pitch; position];
            
            % dimensions of chabo
            vertices        = obj.mChaboPoly.Vertices;
            chabo_heigth    = max(vertices(:,2))-min(vertices(:,2));
            chabo_width     = max(vertices(:,1))-min(vertices(:,1));
            r_tires         = vertices(1,2);

            % chabo polygon
            z_offset            = r_tires;
            chabo               = rotate(obj.mChaboPoly, -rad2deg(y(1,1)), [0, z_offset]);
            chabo               = translate(chabo, y(2,1), 0);
            chaboPlot           = plot(chabo);
            chaboPlot.FaceAlpha = 0.7;
            chaboPlot.LineWidth = 1.5;
            if(nargin > 3)
                chaboPlot.FaceColor = col;
            else
                chaboPlot.FaceColor = 'blue';
            end

            % tires polygon
            d_Tires             = 2 * r_tires;
            wheelPlot           = rectangle('Position', [position-d_Tires/2, 0, d_Tires, d_Tires], 'Curvature', [1,1]);
            wheelPlot.LineWidth = 1.5;
            wheelPlot.FaceColor = 'black';
            
            % flywheel polygon
            flywheel_ratio_diameter     = 0.7;
            flywheel_ratio_distance     = 0.7;
            d_Flywheel                  = chabo_width * flywheel_ratio_diameter;
            l_Flywheel                  = chabo_heigth * flywheel_ratio_distance;
            yPosFlywheel                = z_offset - d_Flywheel/2 + cos(pitch) * l_Flywheel;
            xPosFlywheel                = position - d_Flywheel/2 + sin(pitch) * l_Flywheel;
            flywheelPlot = rectangle('Position', [xPosFlywheel, yPosFlywheel, d_Flywheel, d_Flywheel], 'Curvature', [1,1]);
            flywheelPlot.LineWidth = 1.5;
            rgb_grey = [230 230 230] ./ 255;
            flywheelPlot.FaceColor = rgb_grey;
            
            % return objects
            plotObjects = {chaboPlot; wheelPlot; flywheelPlot};
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
            ylim([-off/2, max(obj.mChaboPoly.Vertices(:,2))+off]);
            xlabel('x coordinate [m]');
            ylabel('z coordinate [m]');
            title('Real World');
        end
        %% Check Configuration Collision
        function isInCollision = checkConfigurationInCollision(obj, y)
            % Construct Chabo
            d = 0.2;
            h = 0.7;
            chabo = polyshape([-d/2, -d/2, d/2, d/2], [d/2, d/2+h, d/2+h, d/2]);
            chabo = rotate(chabo, -rad2deg(y(1,1)), [0, 0.1]);
            chabo = translate(chabo, y(2,1), 0);
            
            % Iterate Obstacles
            isInCollision = false;
            for k = 1:length(obj.mObstacles)
                obs = obj.mObstacles{k,1};
                tmp = intersect(chabo, obs);
                if(tmp.NumRegions > 0)
                    isInCollision = true;
                    break;
                end
            end
        end
    end
end

