function X = simRealTWIPR(u)
    % Setup
    N = length(u);
    X = zeros(4, N);
    x = zeros(4,1);
    X(:, 1) = x;
    % Load Dynamics
    load('twipr_ol_dynamics.mat');
    A = diag([1.0001, 0.9995, 0.999, 0.9995])*A;
    B = diag([1.01, 0.995, 0.99, 0.995])*B;
    for n = 1:N
        x = A*x + B*u(n);
        X(:, n+1) = x;
    end
end

