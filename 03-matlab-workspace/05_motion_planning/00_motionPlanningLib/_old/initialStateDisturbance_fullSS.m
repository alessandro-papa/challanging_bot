function [d1, d1d, d2, d2d] = initialStateDisturbance_fullSS(N, x0)
    load('twipr_ol_dynamics.mat');
    d1  = zeros(N,1);
    d1d = zeros(N,1);
    d2  = zeros(N,1);
    d2d = zeros(N,1);
    C1  = [1, 0, 0, 0];
    C1d = [0, 1, 0, 0];
    C2  = [0, 0, 1, 0];
    C2d = [0, 0, 0, 1];
    for n = 1:N
        d1(n,1)  = C1*A^(n)*x0;
        d1d(n,1) = C1d*A^(n)*x0;
        d2(n,1)  = C2*A^(n)*x0;
        d2d(n,1) = C2d*A^(n)*x0;
    end
end

