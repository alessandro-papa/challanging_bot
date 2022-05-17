function [Aineq, bineq, Aeq, beq] = opt_constraints_v2(N, ps, pe, world, umin, umax,  x0)
%OPT_CONSTRAINTS_V2 Returns constraints for local planing via optimization.
    % Dynamics
    [P1, P2] = lifted_dynamics(N);
    [d1, d2] = initialStateDisturbance(N, x0);
    
    %% linear inequality constraints
    % AIneq * u <= bineq
    
    % Input Constraints     
    G1 = eye(N);
    g1 = umax*ones(N,1);
    G2 = -eye(N);
    g2 = -umin*ones(N,1);
    % First Output Constraints
    [y2min, y2max, y1min, y1max, ~] = local_constraints_v2(ps, pe, world);
    H11 = P1;
    H12 = -P1;
    h11 = y1max*ones(N,1)-d1;
    h12 = -y1min*ones(N,1)+d1;
    % Second Output Constraints
    H21 = P2;
    H22 = -P2;
    h21 = y2max*ones(N,1)-d2;
    h22 = -y2min*ones(N,1)+d2;
    
%     Aineq = [G1; G2; H11; H12; H21; H22];
%     bineq = [g1; g2; h11; h12; h21; h22];
    Aineq = [H11; H12; H21; H22];
    bineq = [h11; h12; h21; h22];
    
    %% linear equality constraints 
    % Aeq * u = beq
    r  = pe;
    a1 = [zeros(1,N-1), 1]*P1; 
    a2 = [zeros(1,N-1), 1]*P2;
    b1 = r(1,1) - d1(end,1);
    b2 = r(2,1) - d2(end,1);
    Aeq = [a1; a2];
    beq = [b1; b2];
end

