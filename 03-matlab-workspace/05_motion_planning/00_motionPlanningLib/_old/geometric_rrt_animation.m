function geometric_rrt_animation(cspace, nodelist)
    figure;
    cspace.draw();
    old_idx = 1;
    idx     = 2;
    while(true)
        draw_nodelist(nodelist(old_idx:idx), 'blue');
        drawnow;
        old_idx = idx;
        idx = round((idx+5)*1.2);
        if(idx > length(nodelist))
            break;
        end
    end
end

