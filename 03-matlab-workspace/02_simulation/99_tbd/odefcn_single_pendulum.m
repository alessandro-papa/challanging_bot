function xd = odefcn_single_pendulum(t, x, u)
    % Parameters
    g = 9.81;
    l = 0.1;
    m = 0.3;
    % State Derivative
    xd = zeros(2,1);
    xd(1,1) = x(2,1);
    xd(2,1) = g/l*sin(x(1,1)) + 1/(m*l^2)*u;
end

