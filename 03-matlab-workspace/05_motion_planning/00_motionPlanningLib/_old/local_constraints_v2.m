function [xmin, xmax, ymin, ymax, box] = local_constraints_v2(ps, pe, configworld)
    % Returns local box constraints for a path segment specified by
    % start point ps and end point pe.
    
    
    % Determine Box Corners
    x = [ps(2,1), pe(2,1)];
    x = sort(x);
    y = [ps(1,1), pe(1,1)];
    y = sort(y);

    xmin = x(1);
    xmax = x(2);
    ymin = y(1);
    ymax = y(2);
    
    % Increment for search
    inc = 0.01;
    
    % Obstacles 
    obstacles   = configworld.mObstacles;
    constraints = configworld.mConstraints;
    % Boundaries
    smin = constraints.mYMin(2,1);
    smax = constraints.mYMax(2,1);
    pmin = constraints.mYMin(1,1);
    pmax = constraints.mYMax(1,1);
    bd   = 0.1;
    leftborder  = polyshape([smin-bd, smin-bd, smin, smin],...
                            [pmin-bd, pmax+bd, pmax+bd, pmin-bd]);
    rightborder = polyshape([smax+bd, smax+bd, smax, smax],...
                            [pmin-bd, pmax+bd, pmax+bd, pmin-bd]);
    topborder   = polyshape([smin, smin, smax, smax],...
                            [pmax, pmax+bd, pmax+bd, pmax]);
    botborder   = polyshape([smin, smin, smax, smax],...
                            [pmin, pmin-bd, pmin-bd, pmin]);
    obstacles{end+1,1} = leftborder;
    obstacles{end+1,1} = rightborder;
    obstacles{end+1,1} = topborder;
    obstacles{end+1,1} = botborder;

    % Iterative Search
    runFlag = true;
    while(runFlag)
        % Inflate Box
        xmin = xmin - inc;
        xmax = xmax + inc;
        ymin = ymin - inc;
        ymax = ymax + inc;
        box = polyshape([xmin, xmin, xmax, xmax], [ymin, ymax, ymax, ymin]);
        % Check Collision

        for k = 1:length(obstacles)
            obs = obstacles{k,1};
            if(overlaps([box, obs]))
                runFlag = false;
            end
        end
    end
    xmin = xmin + inc;
    xmax = xmax - inc;
    ymin = ymin + inc;
    ymax = ymax - inc;
end

