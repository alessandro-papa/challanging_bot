function [Aineq, bineq, Aeq, beq] = opt_constraints_v2(N, pe, umin, umax, ymin, ymax, x0)
%OPT_CONSTRAINTS_V2 Returns constraints for local planing via optimization.
    %% dynamics & initial state
    % Dynamics
    [P1, P1d, P2, P2d] = lifted_dynamics_fullSS(N);
    [d1, d1d, d2, d2d] = initialStateDisturbance_fullSS(N, x0);
   
    %% inequality constraints
    % theta Constraints
    H11 = P1;
    H12 = -P1;
    h11 = ymax(1)*ones(N,1)-d1;
    h12 = -ymin(1)*ones(N,1)+d1;
    
    % thetaD Constraints
    H1d1 = P1d;
    H1d2 = -P1d;
    h1d1 = ymax(2)*ones(N,1)-d1d;
    h1d2 = -ymin(2)*ones(N,1)+d1d;
    
    % s Constraints
    H21 = P2;
    H22 = -P2;
    h21 = ymax(3)*ones(N,1)-d2;
    h22 = -ymin(3)*ones(N,1)+d2;
    
    % sD Constraints
    H2d1 = P2d;
    H2d2 = -P2d;
    h2d1 = ymax(4)*ones(N,1)-d2d;
    h2d2 = -ymin(4)*ones(N,1)+d2d;
    
    % Inequality Constraints
%     Aineq = [G1; G2; H11; H12; H21; H22];   
%     bineq = [g1; g2; h11; h12; h21; h22];   
%     Aineq = [H11; H12; H21; H22];
%     bineq = [h11; h12; h21; h22];
    Aineq = [H11; H12; H1d1; H1d2; H21; H22; H2d1; H2d2];   % dynamic constraints
    bineq = [h11; h12; h1d1; h1d2; h21; h22; h2d1; h2d2];   % dynamic constraints
    
    %% equality constraints
    % Equality Constraints
    % Aeq*x = beq
    r   = pe;
    % get last samples' tf for Aeq
    a1  = [zeros(1,N-1), 1]*P1;
    a1d = [zeros(1,N-1), 1]*P1d; 
    a2  = [zeros(1,N-1), 1]*P2;
    a2d = [zeros(1,N-1), 1]*P2d;
    % set goal state for beq
    b1  = r(1,1) - d1(1);
    b1d = r(2,1) - d1d(1);
    b2  = r(3,1) - d2(1);
    b2d = r(4,1) - d2d(1);
    Aeq = [a1; a1d; a2; a2d];
    beq = [b1; b1d; b2; b2d];
end