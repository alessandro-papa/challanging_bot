function d = twipr_state_distance_tbd(x, Y)
% x = node in state space x = (theta, theta_d, s, s_d)
    % Allocate return structure
    N = size(Y,1);      % length of rows of Y, Y = node map of ALL nodes
    d = zeros(N,1);     % set distance to 0
    % Scaling 
%     ygain = 1./[pi; 8; pi; 4];     % gain scaling to weight angle + position and velocities
%     ygain = 1./[0.1; 8; pi; 4];
    ygain = 1./[0.1; 8; pi; 4];
    % Scale x
    x = x';
    x = ygain.*x;                  % weighted current node
    for n = 1:N                    % iterate through all nodes 
        y = Y(n, :)';
        y = ygain.*y;              % weighted near node
        d(n,1) = norm(x-y);        % corresponding distance
    end
end

 