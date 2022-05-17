function [plan_flag, tree, UP, XP, nodelist] = kinodynamic_planning_mimo(world, xI, xG, K, lmp_func, forward_sim_func, x2yfunc, distance_func, goal_check_probability)
    % Random Samples
    XS = world.randomSamples(K);    % generate K random state space nodes

    % Root Node
    root = CKinodynamicNode(xI, -1, -1, -1, x2yfunc);       % root node of type CKinodynamicNode. 
                                                            % tree is formed as a list of all nodes as children of root node of type CKinodynamicNode
    nmap = CKinodynamicNearestMap(root, distance_func);     % node(list) map of all existing nodes in RRT 

    nodelist = root;
    % RRT
    plan_flag = false;
    tic;
    for k = 1:K
        % Sample
        xS = XS(:, k);                          % get sample node
        if(rand(1,1) > goal_check_probability)  % check if random goal node is used this iteration
            xS = xG;
            goal_flag = true;
        else
            goal_flag = false;
        end
        % Find Nearest Node
        nn = nmap.getNearest(xS);               % get nearest node from current sample node
        % LMP - calc local motion planning
        % planning from current sample to nearest node via local motion
        % planning
        [U, success_flag] = lmp_func(nn.mX, xS);
        if(success_flag == false)               % if no path is found, next iteration
            continue;
        end
        % if local motion planning was successfull, calc local trajectory
        % Forward Simulation
        Xt = forward_sim_func(nn.mX, U);
        
        % Collision Detection
        [inCollision, Xc, Uc] = world.trajInCollision(Xt, U);   % check collision
        if(inCollision && size(Xc,2)==0)                        % if collision AND no local trajectory was calculated, next iteration
            continue;
        end
        new_node = nn.addChild(Xc(:,end), Xc, Uc);              % if local trajectory was calculated, cut just before collision and add node
        nmap.addNode(new_node);                                 % add node to nodemap
        nodelist = [nodelist; new_node];                        % add node and local path to tree 
        if(inCollision == false && goal_flag)                   % if planning was successfull, set flags
            goal_node = new_node;                               % set goal node as latest node
            plan_flag = true;
            break;
        end
    end
    tree = root;                % return tree 
    if(plan_flag)               % if planning was successfull, create trajectory
        XP = goal_node.mXT;     % last node = goal node
        U  = goal_node.mU;
        while(true)             % iterate from goal node to initial node
            goal_node = goal_node.mParent;
            if(goal_node.mParent == -1)
                break;
            end
            XP = [goal_node.mXT(:,[1:end-1]), XP];
            U  = [goal_node.mU; U];
        end
        UP = U;
    else
        UP = -1;
        XP = -1;
    end
end

