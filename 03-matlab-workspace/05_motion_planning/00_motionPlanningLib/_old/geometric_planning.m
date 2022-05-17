function [success_flag, tree, path] = geometric_planning(y_I, y_G, world, distance_func, K, goal_check_probability)
%GEOMETRIC_EXPLORATION Performs geometric exploration by RRT for K
%iterations.

    % Init
    success_flag = false;
    path         = -1;

    % Create Samples
    Y = world.randomConfigurationSamples(K);
    
    % Root Node
    root_node = CGeometricNode(y_I, -1);
    
    % Nearest Map
    nearest_map = CGeometricNearestMap(root_node, distance_func);
       
    % Iterate
    nbrNodes = 0;
    for k = 1:2*K
        % Fetch Sample
        y = Y(:, k);
        % Test Goal State
        coin = rand(1,1);
        if(coin > goal_check_probability)
            coin_flag = true;
            y = y_G;
        else
            coin_flag = false;
        end
        % Get Nearest
        nearest_node = nearest_map.getNearest(y);
        % Check Collision
        inCollision = world.checkLineCollision(nearest_node.mY, y);
        if(inCollision)
            continue;
        end
        % Add to Tree
        new_node = nearest_node.addChild(y);
        % Add to Nearest Map
        nearest_map.addNode(new_node);
        % Check number of nodes
        nbrNodes = nbrNodes + 1;
        if(nbrNodes == K)
            break;
        end
        % Check for Planning Success
        if(coin_flag == true)
            success_flag = true;
            path = new_node.mY;
            current_node = new_node;
            while(1)
                current_node = current_node.mParent;
                path(:, end+1) = current_node.mY;
                if(current_node.mParent == -1)
                    break;
                end
            end
            path = fliplr(path);
            break;
        end
    end
    % Return
    tree = root_node;
end

