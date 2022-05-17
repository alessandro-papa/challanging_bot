classdef CConfigWorld < handle
    %CCONFIGWORLD Class representing the world in configuration space.
    
    properties
        mConstraints
        mObstacles
    end
    
    methods
        %% Constructor
        function obj = CConfigWorld(constraints)
            %CCONFIGWORLD Constructor requiring a constraints object. If no
            %constraints are passed, default constraints are
            %constructed/used.
            if(nargin < 1)
                constraints = CConstraints();
            end
            obj.mConstraints = constraints;
            obj.mObstacles   = {};
        end
        %% Add Obstacle
        function addObstacle(obj, obs)
            obj.mObstacles{end+1,1} = obs;
        end
        %% Draw
        function draw(obj)
            % Boundaries
            smin = obj.mConstraints.mYMin(2,1);
            smax = obj.mConstraints.mYMax(2,1);
            pmin = obj.mConstraints.mYMin(1,1);
            pmax = obj.mConstraints.mYMax(1,1);
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
            tmp = gca;
            for k = 1:length(tmp.YTickLabel)
                ang = str2double(tmp.YTickLabel{k});
                new_label = horzcat(num2str(ang), ' / ', num2str(round(rad2deg(ang)))); 
                tmp.YTickLabel{k} = new_label;
            end
            emlYLabel('pitch [rad / $\circ$]');
            emlXLabel('position [m]');
            grid on;
            ax = gca();
            ax.LineWidth = 2;
            ax.FontSize = 16;
        end
        %% Check Constraint Violation
        function inViolation = checkOutputConstraintViolation(obj, y)
            u_upper = sum(y > obj.mConstraints.mYMax);
            u_lower = sum(y < obj.mConstraints.mYMin);
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
        function [inCollision, shorterPointFlag, ys] = checkLineCollision(obj, y1, y2)
            inCollision      = false;
            shorterPointFlag = true;
            ys               = y2;
            % Line Coordinates
            xline = [y1(2,1), y2(2,1)];
            yline = [y1(1,1), y2(1,1)];
            for k = 1:length(obj.mObstacles)
                obs = obj.mObstacles{k,1};
                [xi,yi] = polyxpoly(xline,yline,obs.Vertices(:,1)',obs.Vertices(:,2)');
                if(isempty(xi) == false)
                    inCollision = true;
                    % Get Intersection Point closest to y1
                    ys = [yi(1,1); xi(1,1)];
                    ds = configuration_distance(y1', ys', obj.mConstraints);
                    if(length(xi) < 2)
                        shorterPointFlag = false;
                        ys = -1;
                        break;
                    end
                    for n = 2:length(xi)
                        yn = [yi(n,1); xi(n,1)];
                        dn = configuration_distance(y1', yn', obj.mConstraints);
                        if(dn < ds)
                            ys = yn;
                            ds = dn;
                        end
                    end
                    ys = y1+0.95*(ys-y1);
                    shorterPointFlag = true;
                    break;
                end
            end
        end
    end
end

