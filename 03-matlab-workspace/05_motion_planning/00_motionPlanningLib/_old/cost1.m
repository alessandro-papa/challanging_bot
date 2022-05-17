function [c, g] = cost1(u)
    c = u'*u;
    g = 2*u;
end

