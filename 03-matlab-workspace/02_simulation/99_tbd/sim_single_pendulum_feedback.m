function [X, U, t] = sim_single_pendulum_feedback(nbr_samples, x0, feedback_func, U_ff)
    if(nargin < 4)
        u_ff = zeros(nbr_samples, 1);
    end
    N = nbr_samples;
    T = 0.02;
    X = zeros(N, 2);
    U = zeros(N, 1);
    x = x0;
    for n = 1:N
        % Compute Input
        u_fb = feedback_func(x);
        u_ff = U_ff(n);
        u    = u_fb + u_ff;
        % Save Values
        X(n, :) = x';
        U(n,1)  = u;
        % ODE
        [t_int,x_int] = ode45(@(t,y) odefcn_single_pendulum(t,y, u), [0, T], x);
        x = x_int(end, :)';
    end
    t = T*(0:N-1)';
end

