classdef CGeometricConfigWorld < handle
    %CGeometricConfigWorld Class for representing the TWIPR's configuration
    %space in a geometric planning setup.
    
    properties
        mPitchMax
        mPitchMin
        mPositionMax
        mPositionMin
        mObstacles
    end
    
    methods
        %% Constructor
        function obj = CGeometricConfigWorld(pitch_max,...
                                             pitch_min,...
                                             position_max,...
                                             position_min)
            obj.mPitchMax    = pitch_max;
            obj.mPitchMin    = pitch_min;
            obj.mPositionMax = position_max;
            obj.mPositionMin = position_min;
            obj.mObstacles   = {};
        end    
        %% Add Obstacle
        function addObstacle(obj, obs)
            obj.mObstacles{end+1,1} = obs;
        end
        %% Draw
        function draw(obj)
            % Boundaries
            smin = obj.mPositionMin;
            smax = obj.mPositionMax;
            pmin = obj.mPitchMin;
            pmax = obj.mPitchMax;
            bd   = 0.1;
            leftborder  = polyshape([smin-bd, smin-bd, smin, smin],...
                                    [pmin-bd, pmax+bd, pmax+bd, pmin-bd]);
            rightborder = polyshape([smax+bd, smax+bd, smax, smax],...
                                    [pmin-bd, pmax+bd, pmax+bd, pmin-bd]);
            topborder   = polyshape([smin, smin, smax, smax],...
                                    [pmax, pmax+bd, pmax+bd, pmax]);
            botborder   = polyshape([smin, smin, smax, smax],...
                                    [pmin, pmin-bd, pmin-bd, pmin]);
            borders = [leftborder, rightborder, topborder, botborder];
            for k = 1:length(borders)
                obs = borders(k);
                p   = plot(obs); hold on;
                p.FaceAlpha = 0.8;
                p.FaceColor = [0.1,0.1,0.1];
                p.EdgeAlpha = 0.8;
                p.EdgeColor = [0.1,0.1,0.1];
            end
            % Obstacles
            for k = 1:length(obj.mObstacles)
                obs = obj.mObstacles{k,1};
                p   = plot(obs); hold on;
                p.FaceAlpha = 0.8;
                p.FaceColor = [0.1,0.1,0.1];
            end
            % Fix Figure
            xlim([smin-bd/2, smax+bd/2]);
            ylim([pmin-bd/2, pmax+bd/2]);
            ylabel('pitch [rad]');
            xlabel('position [m]');
            title('World in C-Space');
            grid on;
            ax = gca();
            ax.LineWidth = 2;
            ax.FontSize = 16;
        end
        %% Check Constraint Violation
        function inViolation = checkOutputConstraintViolation(obj, y)
            ymax = [obj.mPitchMax; obj.mPositionMax];
            ymin = [obj.mPitchMin; obj.mPositionMin];
            u_upper = sum(y > ymax);
            u_lower = sum(y < ymin);
            inViolation = (u_upper + u_lower) > 0;
        end
        %% Check Configuration Collision
        function inCollision = checkConfigCollision(obj, y)
            inCollision = false;
            % Point Coordinates
            xp = y(2,1);
            yp = y(1,1);
            for k = 1:length(obj.mObstacles)
                 obs = obj.mObstacles{k,1};
                 xv  = obs.Vertices(:,1)';
                 yv  = obs.Vertices(:,2)';
                 [in,on] = inpolygon(xp,yp,xv,yv);
                 if(in || on)
                     inCollision = true;
                     break;
                 end
            end
        end
        %% Check Line Collision
        function inCollision = checkLineCollision(obj, y1, y2)
            inCollision      = false;
            % Line Coordinates
            xline = [y1(2,1), y2(2,1)];
            yline = [y1(1,1), y2(1,1)];
            for k = 1:length(obj.mObstacles)
                obs = obj.mObstacles{k,1};
                [xi,yi] = polyxpoly(xline,yline,obs.Vertices(:,1)',obs.Vertices(:,2)');
                if(isempty(xi) == false)
                    inCollision = true;
                    break;
                end
            end
        end
        %% Random Configuration Samples
        function Y = randomConfigurationSamples(obj, K)
            % Allocate
            Ys  = rand(2, 2*K);
            Y   = zeros(2,K);

            % Scaling
            ymin  = [obj.mPitchMin; obj.mPositionMin];
            ymax  = [obj.mPitchMax; obj.mPositionMax];
            ygain = ymax - ymin;
            idx = 1;
            for k = 1:2*K
                % Random sample from 0-1 interval
                y      = Ys(:, k);
                % Scale into configuration space
                y      = ygain.*y + ymin;
                % Check whether it is in free C-space
                if(obj.checkConfigCollision(y))
                    continue;
                end
                % Add to sample matrix
                Y(:,idx) = y;
                idx      = idx + 1;
                if(idx == K)
                    break;
                end
            end
        end
    end
end

