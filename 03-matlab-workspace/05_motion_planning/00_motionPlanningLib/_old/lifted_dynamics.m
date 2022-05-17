function [P1, P2] = lifted_dynamics(N)
    load('chabo_as_twipr_ol_dynamics.mat');
    p1 = zeros(N,1);
    p2 = zeros(N,1);
    C1 = [1, 0, 0, 0];
    C2 = [0, 0, 1, 0];
    for n = 1:N
        p1(n,1) = C1*A^(n-1)*B;
        p2(n,1) = C2*A^(n-1)*B;
    end
    P1 = tril(toeplitz(p1));
    P2 = tril(toeplitz(p2));
end

