function [para] = getChaboParameters()
% chabo v6 (see fusion project chabo)
% EC90 motor + ESCON 70/10. light flywheel (1.6kg).
%%   masses  
    para.m1         = 0;     % body + flywheel
    para.m2         = 0;     % whole robot
    para.mB         = 3.95;  % body
    para.mT         = 1.5;   % both tires
    para.mF         = 1.6;   % flywheel
%%   moments of inertia (body + flywheel)
%   IB with respect to center of mass
    para.IB         = 0.033;
%   IB_A with respect to A (wheels axis)
    para.IB_A       = 0.0;      % preallocate memory
    para.IT         = 6e-3;     % tires
    para.IF         = 3e-3;     % flywheel
%%   geometry
    para.l          = 0.019;    % distance COM to wheel axis
    para.r          = 0.0875;   % radius of wheels
%%   physics
    para.g          = 9.81;
%%   input constraints
    para.uTmax      = 2;    % [Nm]
    para.uFmax      = 3;    % [Nm]
    para.psiDmax    = 210;  % [rad/sec]
%%   calculate masses
    para.m1 = para.mB + para.mF;
    para.m2 = para.mB + para.mF + para.mT;
%%   calculate moment of inertia with respect to A | IB_A
    para.IB_A = para.IB + para.m1 * para.l^2;
end