function d = configuration_distance(x, Y)
%CONFIGURATION_DISTANCE Computes distances between configuration x and
%configurations Y, where scaling is determined by constraints.
% For compatability with knnsearch, x is 1x2, and Y is Nx2.
    % Allocate return structure
    N = size(Y,1);
    d = zeros(N,1);
    % Scaling
    yoff  = [0;0];
    ygain = [1; 1];
    % Scale x
    x = x';
    x = ygain.*(x - yoff);
    for n = 1:N
        y = Y(n, :)';
        y = ygain.*(y - yoff);
        d(n,1) = norm(x-y);
    end
end

