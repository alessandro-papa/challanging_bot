function [P1, P1d, P2, P2d] = lifted_dynamics_fullSS(N)
    load('chabo_as_twipr_ol_dynamics.mat');
    p1  = zeros(N,1);
    p1d = zeros(N,1);
    p2  = zeros(N,1);
    p2d = zeros(N,1);
    C1  = [1, 0, 0, 0];
    C1d = [0, 1, 0, 0];
    C2  = [0, 0, 1, 0];
    C2d = [0, 0, 0, 1];
    for n = 1:N
        p1(n,1)  = C1*A^(n-1)*B;
        p1d(n,1) = C1d*A^(n-1)*B;
        p2(n,1)  = C2*A^(n-1)*B;
        p2d(n,1) = C2d*A^(n-1)*B;
    end
    P1 = tril(toeplitz(p1));
    P1d = tril(toeplitz(p1d));
    P2 = tril(toeplitz(p2));
    P2d = tril(toeplitz(p2d));
end

