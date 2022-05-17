function plot_error_norm_mimo(ret)
    j = 0:length(ret.eN)-1;
    
    plot(j, ret.eN, '-o'); hold on;
    plot(j, ret.e1N, '--o'); 
    plot(j, ret.e2N, '--o');
    emlXLabel('trial');
    emlYLabel('normalized error norm');
    emlLegend({'absolute', 'pitch', 'position'}, 'ne');
end

