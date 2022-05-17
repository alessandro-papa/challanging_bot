function tree = kinodynamic_exploration(world, xI, K, lmp_func, forward_sim_func, x2yfunc, distance_func)
    % Random Samples
    XS = world.randomSamples(K);    % K local goals in state space

    % Root Node
    root = CKinodynamicNode(xI, -1, -1, -1, x2yfunc);
    nmap = CKinodynamicNearestMap(root, distance_func);

    % RRT
    tic;
    for k = 1:K
        % Sample
        xS = XS(:, k);
        % Find Nearest Node
        nn = nmap.getNearest(xS);
        % LMP
        [U, success_flag] = lmp_func(nn.mX, xS);
        if(success_flag == false)
            continue;
        end
        % Forward Simulation
        Xt = forward_sim_func(nn.mX, U);
        % Collision Detection
        [inCollision, Xc, Uc] = world.trajInCollision(Xt, U);
        if(inCollision && size(Xc,2)==0)
            continue;
        end
        new_node = nn.addChild(Xc(:,end), Xc, Uc);
        nmap.addNode(new_node);
    end
    tree = root;
end

