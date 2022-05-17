function [fig] = plot_lqr_lin(X,U, constraints)
%PLOT_LQR plot time-domain results of lqr experiment
%   X = state vector trajectory
%   U = input vector trajectory
%   constraints = limiting constraint of robot
%% create time vector
N = length(X(1,:));
t = 0.02*(0:N-1)';
%% plot result
fig = figure;
fig.Position = [100 100 1200 600];
% pitch plot
subplot(2,3,[1,4]); hold on; grid on;
plot(t, rad2deg(X(1,:))); 
emlXLabel('time [s]');
emlYLabel(['pitch [$^\circ$]']);

% position plot
subplot(2,3,2); hold on; grid on;
plot(t, X(3,:));
emlXLabel('time [s]');
emlYLabel('position x [m]');

% flywheel velocity plot
subplot(2,3,3); hold on; grid on;
plot(t, X(5,:));
yline(constraints.flywheelVelocityMax,'--k', 'LineWidth', 2);
yline(-constraints.flywheelVelocityMax,'--k', 'LineWidth', 2);
emlXLabel('time [s]');
emlYLabel('flywheel velocity [$\frac{rad}{sec}$]');

% tires torque plot
subplot(2,3,5); hold on; grid on;
plot(t, U(1,:));
yline(constraints.tiresTorqueMax,'--k', 'LineWidth', 2);
yline(-constraints.tiresTorqueMax,'--k', 'LineWidth', 2);
emlXLabel('time [s]');
emlYLabel('tires torque [Nm]');

% flywheel torque plot
subplot(2,3,6); hold on; grid on;
plot(t, U(2,:));
yline(constraints.flywheelTorqueMax,'--k', 'LineWidth', 2);
yline(-constraints.flywheelTorqueMax,'--k', 'LineWidth', 2);
emlXLabel('time [s]');
emlYLabel('flywheel torque [Nm]');
end

