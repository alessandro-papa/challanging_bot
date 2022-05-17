function draw_nodelist(nodelist, col)
    for n = 2:length(nodelist)
        node   = nodelist(n);
        parent = node.mParent;
        
        % Line
        xp = [parent.mY(2,1), node.mY(2,1)];
        yp = [parent.mY(1,1), node.mY(1,1)];
        line(xp, yp, 'LineWidth', 1.1, 'Color', col);
    end
end

