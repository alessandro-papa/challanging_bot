function xd = chaboNLDynamics(x, u, p)
%% full SS non-linear dynamics model of chabo. Version depending on getChaboParameter()
    % load physical parameters
%     load('chabo_parameters.mat');
%     p = chaboParameters;
    % calc factors
    V1 = (p.IB+p.m1*p.l^2)*(p.m2+p.IT/p.r^2)-p.m1^2*p.l^2*cos(x(1))^2;
    V2 = p.IF;
    C1 = (p.m2+p.IT/p.r^2)*p.m1*p.l*p.g;
    C2 = p.m1^2*p.l^2*cos(x(1));
    C3 = p.m1^2*p.l^2*p.g*cos(x(1));
    C4 = (p.IB+p.m1*p.l^2)*p.m1*p.l;
    B1 = p.m2+p.IT/p.r^2+p.m1*p.l/p.r*cos(x(1));
    B2 = p.m2+p.IT/p.r^2;
    B3 = p.m1*p.l*cos(x(1))+(p.IB+p.m1*p.l^2)/p.r;
    B4 = p.m1*p.l*cos(x(1));
    
    f1 = sin(x(1))/V1*(C1+C2*x(2)^2);
    f2 = -sin(x(1))/V1*(C3+C4*x(2)^2);
    
    % calculate differential equation
    xd    = zeros(5,1);
    xd(1) = x(2);
    xd(2) = f1-B1/V1*u(1)-B2/V1*u(2);
    xd(3) = x(4);
    xd(4) = f2+B3/V1*u(1)+B4/V1*u(2);
%     xd(5) = x(6);
    xd(5) = 1/V2*u(2);
end
