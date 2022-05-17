function [fig] = plot_lqr_simulation_study(X, U, constraints)
% plotSimulationStudyLQR plot simulation study of 3 different controllers 
%   X = state vector trajectory
%   U = input vector trajectory
%   constraints = limiting constraint of robot
for i=1:length(X)
    X{i} = X{i}';
    U{i} = U{i}';
end
%% create time vector
N = length(U{1}(1,:));
t = 0.02*(0:N-1)';
%% plot result
fig = figure;
fig.Position = [100 100 1500 900];
% pitch plot
subplot(2,3,[1,4]); hold on; grid on;
% plot(t, rad2deg(X(1,:)),'LineWidth', 2);
plot(t, rad2deg(X{1}(1,:))); 
plot(t, rad2deg(X{2}(1,:))); 
plot(t, rad2deg(X{3}(1,:))); 
emlXLabel('time [s]');
emlYLabel(['pitch angle [$^\circ$]']);
emlLegend({'K1', 'K2', 'K3'}, 'ne');

% position plot
subplot(2,3,2); hold on; grid on;
plot(t, X{1}(3,:));
plot(t, X{2}(3,:));
plot(t, X{3}(3,:));
emlXLabel('time [s]');
emlYLabel('position [m]');
emlLegend({'K1', 'K2', 'K3'}, 'ne');

% flywheel velocity plot
subplot(2,3,3); hold on; grid on;
plot(t, X{1}(5,:));
plot(t, X{2}(5,:));
plot(t, X{3}(5,:));
yline(constraints.flywheelVelocityMax,'--k', 'LineWidth', 2);
yline(-constraints.flywheelVelocityMax,'--k', 'LineWidth', 2);
emlXLabel('time [s]');
emlYLabel('flywheel velocity [$\frac{rad}{sec}$]');
emlLegend({'K1', 'K2', 'K3'}, 'ne');

% uT plot
subplot(2,3,5); hold on; grid on;
plot(t, U{1}(1,:));
plot(t, U{2}(1,:));
plot(t, U{3}(1,:));
yline(constraints.tiresTorqueMax,'--k', 'LineWidth', 2);
yline(-constraints.tiresTorqueMax,'--k', 'LineWidth', 2);
emlXLabel('time [s]');
emlYLabel('tires torque [Nm]');
emlLegend({'K1', 'K2', 'K3'});

% uF plot
subplot(2,3,6); hold on; grid on;
plot(t, U{1}(2,:));
plot(t, U{2}(2,:));
plot(t, U{3}(2,:));
yline(constraints.flywheelTorqueMax,'--k', 'LineWidth', 2);
yline(-constraints.flywheelTorqueMax,'--k', 'LineWidth', 2);
emlXLabel('time [s]');
emlYLabel('flywheel torque [Nm]');
emlLegend({'K1', 'K2', 'K3'});

end

