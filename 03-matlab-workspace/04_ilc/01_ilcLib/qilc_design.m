function [Q, L] = qilc_design(P, QW, SW, RW)
    Q = (P'*QW*P + RW + SW)\(P'*QW*P+SW);
    L = (P'*QW*P + SW)\P'*QW;
end

