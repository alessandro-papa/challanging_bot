function [fig] = plot_ilc_mimo_linear(ret, chabo_ol_disc, K, constraints)
%plot simulation results of mimo ilc 
%   error norm progressions (pitch + position), last trials' output references
%   and torques + flyhwheel velocity

N = length(ret.r)/2;
t  = (0:0.02:(N-1)*0.02)';

u_ilc     = ret.Uc{end};


y         = ret.Yc{end};
u_control = get_controller_output_mimo(ret,chabo_ol_disc, K);
X         = get_state_vector_mimo(ret,chabo_ol_disc, K);

% create figure
fig = figure;
fig.Position = [20 20 1500 900];
subplot(2,3,1);
plot_error_norm_mimo(ret);
xlabel('trials');
ylabel('euclidean error norm')

% pitch plot
subplot(2,3,2);
plot(t, rad2deg(y(1:2:end))); hold on;
plot(t, rad2deg(ret.r(1:2:end)), '--', 'Color', 'black');
xlabel('time [s]');
ylabel('pitch [$^\circ$]');
xlim([0 max(t)+0.01]);
legend({'$\theta_\mathrm{10}$', '$r_\mathrm{1}$'});
title('pitch trajectory on last trial');

% position plot
subplot(2,3,3);
plot(t, y(2:2:end)); hold on;
plot(t, ret.r(2:2:end), '--', 'Color', 'black');
xlabel('time [s]');
ylabel('position [m]');
xlim([0 max(t)+0.01]);
legend({'$s_\mathrm{10}$', '$r_\mathrm{2}$'}, 'Location', 'nw');
title('position trajectory on last trial');

% tires torque
subplot(2,3,4);
plot(t, (u_ilc(1:2:end)) + u_control{end}(1,:)'); hold on;
ylim([-2.2 2.2]);
yline(constraints.tiresTorqueMax, '--k', 'LineWidth', 3);
yline(-constraints.tiresTorqueMax, '--k', 'LineWidth', 3);
xlabel('time [s]');
ylabel('torque [Nm]');
xlim([0 max(t)+0.01]);
legend({'$u_\mathrm{T}$'}, 'Location', 'nw');
title('tires torque on last trial');

% flywheel torque
subplot(2,3,5);
plot(t, (u_ilc(2:2:end) + u_control{end}(2,:)')); hold on;
ylim([-3.2 3.2]);
yline(constraints.flywheelTorqueMax, '--k', 'LineWidth', 3);
yline(-constraints.flywheelTorqueMax, '--k', 'LineWidth', 3);
xlabel('time [s]');
ylabel('torque [Nm]');
xlim([0 max(t)+0.01]);
legend({'$u_\mathrm{F}$'}, 'Location', 'nw');
title('flywheel torque on last trial');

% flywheel velocity
subplot(2,3,6);
plot(t, X{end}(:,5)); hold on;
yline(constraints.flywheelVelocityMax, '--k', 'LineWidth', 3);
yline(-constraints.flywheelVelocityMax, '--k', 'LineWidth', 3);
xlabel('time [s]');
ylabel('velocity [$\frac{rad}{sec}$]');
xlim([0 max(t)+0.01]);
legend({'$\dot{\psi}$'}, 'Location', 'nw');
title('flywheel velocity on last trial');
end

