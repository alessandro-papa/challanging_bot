function [X, U, t] = simChaboDynamics(Kd,x0,nbrOfSamples,U_feedforward_raw)
%SIMCHABODYNAMICS Simulate Chabo's nonlinear dynamics with given feedback controller
    U_feedforward = zeros(nbrOfSamples,2);
    if (nargin==4)
        U_feedforward(:,1) = U_feedforward_raw(1:2:end,1);
        U_feedforward(:,2) = U_feedforward_raw(2:2:end,1);
    end
    
%     Kd = [Kd(:,1:4), [0;0], Kd(:,5)];
    N = nbrOfSamples;
    T = 0.02;
    X = zeros(N, 5);
    U = zeros(N, 2);
    x = x0;
    % load chabo physical parameters
    load('chabo_parameters.mat');
    for n = 1:N
        % compute input
        u_feedback      = - Kd * x;
        u_feedforward   = U_feedforward(n,:);
        u               = u_feedback' + u_feedforward;
        % save values
        X(n,:) = x';
        U(n,:) = u;
        % ODE
        [t_int,x_int] = ode45(@(t,y) chaboNLDynamics(y,u,chaboParameters), [0, T], x);
        x = x_int(end,:)';
    end
    t = T*(0:N-1);
end

