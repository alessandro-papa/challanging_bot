function ret = run_ilc_mimo_linear(r, P, Q, L, J, u0, d)
    if(nargin < 7)
        d = 0;
    end
    if(nargin < 6)
        u0 = zeros(length(r),1);
    end
    % Return Structure
    ret.Yc  = cell(J+1,1);
    ret.Uc  = cell(J+1,1);
    ret.eN  = zeros(J+1,1);
    ret.e1N = zeros(J+1,1);
    ret.e2N = zeros(J+1,1);
    ret.r   = r;
    ret.P   = P;
    
    % Initial trajectories
    u = u0;
    y = P*u + d;
    e = r-y;
    % save initial trajectories in return cells
    ret.Yc{1}  = y;
    ret.eN(1)  = norm(e);
    ret.e1N(1) = norm(e(1:2:end));
    ret.e2N(1) = norm(e(2:2:end));
    
    % Iterate
    for j = 1:J
        u = Q*(u + L*e);
        y = P*u + d;
        e = r-y;
        % Save Values
        ret.Yc{j+1}  = y;
        ret.Uc{j+1}  = u;
        ret.eN(j+1)  = norm(e);
        ret.e1N(j+1) = norm(e(1:2:end));
        ret.e2N(j+1) = norm(e(2:2:end));
    end
end