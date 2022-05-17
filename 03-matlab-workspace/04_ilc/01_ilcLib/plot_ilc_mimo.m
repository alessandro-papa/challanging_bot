function [fig] = plot_ilc_mimo(ilc_data, constraints)
% plot simulation results of mimo ilc's last trial
    t = 0.02 * [0:length(ilc_data.r)/2-1];
    fig = figure;
    fig.Position = [20 20 1500 900];
    subplot(2,3,1);
    plot_error_norm_mimo_v2(ilc_data.eN, ilc_data.e1N, ilc_data.e2N);
    xlabel('trials');
    ylabel('euclidean error norm')
    
    % pitch plot
    subplot(2,3,2);
    plot(t, rad2deg(ilc_data.X{end}(:,1))); hold on;
    plot(t, rad2deg(ilc_data.r(1:2:end)), '--', 'Color', 'black');
    xlabel('time [s]');
    ylabel('pitch [$^\circ$]');
    xlim([0 max(t)+0.01]);
    legend({'$\theta_\mathrm{10}$', '$r_\mathrm{1}$'});
    title('pitch trajectory on last trial');
    
    % position plot
    subplot(2,3,3);
    plot(t, ilc_data.X{end}(:,3)); hold on;
    plot(t, ilc_data.r(2:2:end), '--', 'Color', 'black');
    xlabel('time [s]');
    ylabel('position [m]');
    xlim([0 max(t)+0.01]);
    legend({'$s_\mathrm{10}$', '$r_\mathrm{2}$'}, 'Location', 'nw');
    title('position trajectory on last trial');
    
    % uT
    subplot(2,3,4);
    plot(t, ilc_data.Uc{end}(1:2:end,1)); hold on;
    ylim([-2.2 2.2]);
    yline(constraints.tiresTorqueMax, '--k', 'LineWidth', 3);
    yline(-constraints.tiresTorqueMax, '--k', 'LineWidth', 3);
    xlabel('time [s]');
    ylabel('torque [Nm]');
    xlim([0 max(t)+0.01]);
    legend({'$u_\mathrm{T}$'}, 'Location', 'nw');
    title('tires torque on last trial');
    
    % uF
    subplot(2,3,5);
    plot(t, ilc_data.Uc{end}(2:2:end,1)); hold on;
    ylim([-3.2 3.2]);
    yline(constraints.flywheelTorqueMax, '--k', 'LineWidth', 3);
    yline(-constraints.flywheelTorqueMax, '--k', 'LineWidth', 3);
    xlabel('time [s]');
    ylabel('torque [Nm]');
    xlim([0 max(t)+0.01]);
    legend({'$u_\mathrm{F}$'}, 'Location', 'nw');
    title('flywheel torque on last trial');
    
    % psiD
    subplot(2,3,6);
    plot(t, ilc_data.X{end}(:,6)); hold on;
    yline(constraints.flywheelVelocityMax, '--k', 'LineWidth', 3);
    yline(-constraints.flywheelVelocityMax, '--k', 'LineWidth', 3);
    xlabel('time [s]');
    ylabel('velocity [$\frac{rad}{sec}$]');
    xlim([0 max(t)+0.01]);
    legend({'$\dot{\psi}$'}, 'Location', 'nw');
    title('flywheel velocity on last trial');
end

