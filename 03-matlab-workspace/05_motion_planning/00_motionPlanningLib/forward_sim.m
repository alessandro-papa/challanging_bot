function X = forward_sim(xI, U, A, B)
    N = length(U)/size(B, 2);
    X = zeros(length(xI), N+1);
    X(:,1) = xI;
    x = xI;
    for n = 1:N
        u = U(1+size(B,2)*(n-1):size(B,2)*n);
        x = A*x + B*u;
        X(:, n+1) = x;
    end  
end