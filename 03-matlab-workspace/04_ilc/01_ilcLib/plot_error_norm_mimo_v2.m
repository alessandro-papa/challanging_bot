function plot_error_norm_mimo_v2(eN,e1N,e2N)
    j = 0:length(eN)-1;
    
    plot(j, eN, '-o'); hold on;
    plot(j, e1N, '--o'); 
    plot(j, e2N, '--o');
    emlXLabel('trial');
    emlYLabel('normalized error norm');
    emlLegend({'absolute', 'pitch', 'position'}, 'ne');
end

