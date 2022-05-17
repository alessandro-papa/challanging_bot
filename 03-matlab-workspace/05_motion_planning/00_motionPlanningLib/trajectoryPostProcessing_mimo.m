function [Xnew,Unew] = trajectoryPostProcessing_mimo(xI, xG, XP, UP, world, lmp_func, forward_sim_func)
% postprocessing = find more elegant trajectories 
% from initial state xI to goal state xG
% XP = list of states
% Heuristic increment for efficient search
% TODO check first part of postprocessing, does not work properly
    inc = 2;
    % Find latest state that can be reached from initial state
    for n = 20:inc:size(XP,2)   % size of columns of XP = state space trajectory
        [u, success_flag] = lmp_func(xI, XP(:, n));
        if(success_flag == false)
            break;                  % if no success, terminate loop at n
        end
        % if LMP was successfull, calculate Ctrajectory to check collision 
        % Forward Simulation
        Xt = forward_sim_func(xI, u);
        % Collision Detection
        inCollision = world.trajInCollision(Xt, u);
        if(inCollision)
            break;                  % if collision, terminate loop at n
        end
        % if success and no collision, next iteration
    end
    
    % Readjust path
    u    = lmp_func(xI, XP(:, n));      % n-th input trajectory which leads to a feasible path
    xnew = forward_sim_func(xI, u);     % resulting state trajectory
    
    utmp = UP((n*2-1:end));
    xtmp = XP(:, n+1:end);
    
    Unew = [u; utmp];       % append u vectors starting at sample n
    Xnew = [xnew, xtmp];    % append X vectors starting at sample n
    

    inc = 2;
    % Find earliest state from which the goal state can be reached
    tick = 0;
    for n = size(xnew,2):inc:size(Xnew,2)
        [u, success_flag] = lmp_func(Xnew(:,n), xG);
        if(success_flag == false)
            continue;
        end
        % Forward Simulation
        Xt = forward_sim_func(Xnew(:,n), u);
        % Collision Detection
        [inCollision, Xc, Uc] = world.trajInCollision(Xt, u);
        if(inCollision)
            continue;
        end 
        tick = tick + 1;
        if(tick == 5)
            break;
        end
%         break;
    end
    
    % Adjust path
    u = lmp_func(Xnew(:, n), xG);
    xnew = forward_sim_func(Xnew(:, n), u);
    Xnew = [Xnew(:, 1:n-1), xnew];
    Unew = [Unew(1:(2*n-2)); u];
end

