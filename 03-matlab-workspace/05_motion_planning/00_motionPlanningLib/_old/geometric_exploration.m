function [tree, nodelist] = geometric_exploration(y_I, world, distance_func,  K)
    %GEOMETRIC_EXPLORATION Performs geometric exploration by RRT for K
    %iterations.

    % Create Samples
    Y = world.randomConfigurationSamples(K);
    
    % Root Node
    root_node = CGeometricNode(y_I, -1);
    nodelist = root_node;
    
    % Nearest Map
    nearest_map = CGeometricNearestMap(root_node, distance_func);
    
    % Iterate
    nbrNodes = 0;
    for k = 1:K
        % Fetch Sample
        y = Y(:, k);
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
        nodelist = [nodelist; new_node];
        % Check number of nodes
        nbrNodes = nbrNodes + 1;
        if(nbrNodes == K)
            break;
        end
    end
    % Return
    tree = root_node;
end

