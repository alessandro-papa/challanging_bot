function P = lifted_dynamics_chabo(A, B, C, N)
    m = size(C,1);          
    r = size(B, 2);
    mat_cell = cell(N+1,1);
    mat_cell{1,1} = zeros(m, r);
    for n = 1:N
        subP = C*A^(n-1)*B;         % calc markov parameters, with m = 1, i-q = 0
        mat_cell{n+1,1} = subP;     % save in column vector 
    end
    select_matrix = tril(toeplitz(1:N))+1;
    P = cell2mat(mat_cell(select_matrix));  % generate P-matrix out of column vector 
end