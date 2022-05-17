classdef CKinodynamicConfigWorld < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mXMax
        mXMin
        mUMax
        mUMin
        mObstacles
        mX2YFunc
    end
    
    methods
        function obj = CKinodynamicConfigWorld(xmax, xmin, umax, umin, x2yfunc)
            obj.mXMax = xmax;
            obj.mXMin = xmin;
            obj.mUMax = umax;
            obj.mUMin = umin;
            obj.mObstacles = cell(0,0);
            obj.mX2YFunc   = x2yfunc;
        end
        function addObstacle(obj, obs)
            obj.mObstacles{end+1,1} = obs;
        end
        function draw(obj)
            ymax = obj.mX2YFunc(obj.mXMax);
            ymin = obj.mX2YFunc(obj.mXMin);
            y1off = (ymax(1,1)-ymin(1,1))*0.05;
            y2off = (ymax(2,1)-ymin(2,1))*0.05;
            p1 = polyshape([ymin(1,1)-y1off, ymin(1,1)-y1off,...
                            ymax(1,1)+y1off, ymax(1,1)+y1off],...
                            [ymin(2,1)-y2off, ymax(2,1)+y2off,...
                            ymax(2,1)+y2off, ymin(2,1)-y2off]);
            p2 = polyshape([ymin(1,1), ymin(1,1), ymax(1,1), ymax(1,1)],...
                           [ymin(2,1), ymax(2,1), ymax(2,1), ymin(2,1)]);
            p  = subtract(p1, p2); hold on;
            l = plot(p);
            l.FaceAlpha = 0.8;
            l.FaceColor = 0.3*ones(1,3);
            %daspect([1,1,1]);
            xlim([ymin(1,1)-y1off/2, ymax(1,1)+y1off/2]);
            ylim([ymin(2,1)-y2off/2, ymax(2,1)+y2off/2]);
            for n = 1:length(obj.mObstacles)
                o = obj.mObstacles{n};
                l = plot(o);
                l.FaceAlpha = 0.8;
                l.FaceColor = 0.3*ones(1,3);
            end
            xlabel('position [m]');
            ylabel('pitch [rad]');
        end
        function inCollision = stateInCollision(obj, x)
            inCollision = false;
            % Compute Configurations
            y    = obj.mX2YFunc(x);
            ymax = obj.mX2YFunc(obj.mXMax);
            ymin = obj.mX2YFunc(obj.mXMin);
            % Check Boundary Constraints
            if(sum(y <= ymax) ~= length(y) || ...
               sum(y >= ymin) ~= length(y))
                inCollision = true;
                return;
            end
            % Check Obstacles
            for n = 1:length(obj.mObstacles)
                obs = obj.mObstacles{n,1};
                if(inpolygon(y(1,1), y(2,1), obs.Vertices(:,1), obs.Vertices(:,2)))
                    inCollision = true;
                    break; 
                end
            end
        end
        function inCollision = lineInCollision(obj, x1, x2)
            inCollision = false;
            % Compute configurations
            y1 = obj.mX2YFunc(x1);
            y2 = obj.mX2YFunc(x2);
            % Line in Map Coordinates
            lx = [y1(1,1); y2(1,1)];
            ly = [y1(2,1); y2(2,1)];
            % Check States
            if(obj.stateInCollision(x1) || ...
               obj.stateInCollision(x2) )
                inCollision = true;
                return;
            end
            % Check Obstacles
            for n = 1:length(obj.mObstacles)
                obs = obj.mObstacles{n,1};
                xi = polyxpoly(lx, ly, obs.Vertices(:,1), obs.Vertices(:,2));
                if(isempty(xi) == false)
                    inCollision = true;
                    break;
                end
            end
        end
        function [inCollision, Xc, Uc] = trajInCollision(obj, X, U)
            inCollision = false;
            Xc = X;
            Uc = U;
            N = size(X,2);
            for n = 1:N-1
                x  = X(:,n);
                xp = X(:,n+1);
                if(obj.lineInCollision(x, xp))
                    inCollision = true;
                    Xc = X(:, 1:n-1);
                    Uc = U(1:length(obj.mUMax)*n-length(obj.mUMax),1);
                    break;
                end
            end
        end
        function X = randomSamples(obj, N)
            X = zeros(length(obj.mXMax), N);
            idx = 1;
            while(true)
                x = obj.mXMin + (obj.mXMax-obj.mXMin).*rand(length(obj.mXMax),1);
                if(obj.stateInCollision(x) == false)
                    X(:, idx) = x;
                    idx = idx + 1;
                    if(idx > N)
                        break;
                    end
                end
            end
        end
    end
end

