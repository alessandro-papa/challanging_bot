function [c] = cost2(u)
    global x0;
    N = length(u);   
    P = cell(4,1);
    x = cell(4,1);
    [P{1}, P{2}, P{3}, P{4}] = lifted_dynamics_fullSS(N);
    [d{1}, d{2}, d{3}, d{4}] = initialStateDisturbance_fullSS(N, x0);
    
    for i = 1:4
        x{i}(:,1) = P{i}*u + d{i};
    end
    
%       c = x{1}'*x{1} + x{2}'*x{2} + x{3}'*x{3} + x{4}'*x{4} + u'*u;
%       c = x{1}'*x{1} + x{2}'*x{2} + u'*u;
%       c = x{1}'*x{1} + x{2}'*x{2};
%       c = 0.5 * x{2}'*x{2} + u'*u;
%         c = x{2}'*x{2};
        c = x{1}'*x{1};
%       c = u'*u;
end

