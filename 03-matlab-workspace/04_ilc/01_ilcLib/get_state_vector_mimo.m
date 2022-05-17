function [X] = get_state_vector_mimo(ret, chabo_ol_disc, K)
    T             = 0.02;
    N             = length(ret.r) / 2; 
    t             = (0:T:(N-1)*T)';
    uc            = cell(length(ret.Uc),1);
    X             = cell(length(ret.Uc),1);
    chabo_cl_disc = ss(chabo_ol_disc.A-chabo_ol_disc.B*K, chabo_ol_disc.B, chabo_ol_disc.C, chabo_ol_disc.D, T);
    for j = 2 : length(ret.Uc)  % iterate through trials, skip 1st trial (0000)
    [~, ~, X{j}]  = lsim(chabo_cl_disc, [ret.Uc{j}(1:2:end)'; ret.Uc{j}(2:2:end)'], t, zeros(5,1));
    uc{j}         = -K * X{j}';
    end  
end