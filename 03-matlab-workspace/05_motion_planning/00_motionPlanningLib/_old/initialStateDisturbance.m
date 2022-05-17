function [d1, d2] = initialStateDisturbance(N, x0)
    load('twipr_ol_dynamics.mat');
    d1 = zeros(N,1);
    d2 = zeros(N,1);
    C1 = [1, 0, 0, 0];
    C2 = [0, 0, 1, 0];
    for n = 1:N
        d1(n,1) = C1*A^(n)*x0;
        d2(n,1) = C2*A^(n)*x0;
    end
end

