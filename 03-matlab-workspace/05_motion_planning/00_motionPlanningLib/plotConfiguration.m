function plotConfiguration(y, col)
    if(nargin < 2)
        plot(y(2,1), y(1,1), 'x', 'MarkerSize', 20, 'LineWidth', 2);
    else
        plot(y(2,1), y(1,1), 'x', 'MarkerSize', 20, 'LineWidth', 2, 'Color', col);
    end
end

