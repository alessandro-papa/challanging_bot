function ret = run_ilc_mimo(r, Kd, Q, L, J, u0, d)
    if(nargin < 7)
        d = 0;
    end
    if(nargin < 6)
        u0 = zeros(length(r),1);
    end
    % initial condition
    x0 = [0;0;0;0;0;0;];

    % Return Structure
    ret.X   = cell(J+1,1);
    ret.Yc  = cell(J+1,1);
    ret.Uc  = cell(J+1,1);
    ret.eN  = zeros(J+1,1);
    ret.e1N = zeros(J+1,1);
    ret.e2N = zeros(J+1,1);
    ret.r   = r;
    
    % Initial trajectories
    u = u0;
    [X,U,t] = simChaboDynamics(Kd, x0, length(r)/2, u0);
    pitch    = X(:,1);
    position = X(:,3);
    y        = reshape([pitch'; position'], length(r), 1);
    e        = r-y;
    % save initial trajectories in return cells
    ret.X{1}   = X;
    ret.Yc{1}  = y;
    ret.Uc{1}  = u;
    ret.eN(1)  = norm(e);
    ret.e1N(1) = norm(e(1:2:end));
    ret.e2N(1) = norm(e(2:2:end));
    
    % Iterate
    for j = 1:J
        u = Q*(u + L*e);
        % Simulate current iteration
        [X,U,t] = simChaboDynamics(Kd, x0, length(r)/2, u);
        pitch    = X(:,1);
        position = X(:,3);
        y        = reshape([pitch'; position'], length(r), 1);
        e = r-y;
        % Save Values
        ret.X{j+1}   = X;
        ret.Yc{j+1}  = y;
        ret.Uc{j+1}  = u;
        ret.eN(j+1)  = norm(e);
        ret.e1N(j+1) = norm(e(1:2:end));
        ret.e2N(j+1) = norm(e(2:2:end));
    end
end