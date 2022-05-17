function [X, U, t] = sim_double_pendulum_feedforward(nbr_samples, x0, U)
    N = nbr_samples;
    T = 0.02;
    X = zeros(N, 4);
    x = x0;
    for n = 1:N
        % Save State
        X(n, :) = x';
        % ODE
        [t_int,x_int] = ode45(@(t,y) odefcn_double_pendulum(t,y, U(n)), [0, T], x);
        x = x_int(end, :)';
    end
    t = T*(0:N-1)';
end

