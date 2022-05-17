function [ANc,RIc] = lmp_precompute_mimo(N, A, B)
    ANc = cell(N,1);
    RIc = cell(N,1);
    
    R   = B;
    ABn = B;
    for n = 1:N
        ANc{n,1} = A^n;         % A^N 
        RIc{n,1} = pinv(R);     % RN+ (pseudeinverse of RN)
        ABn = A*ABn;            % calculate A^(n)B
        R   = [ABn, R];         % RN(n)
    end
end

