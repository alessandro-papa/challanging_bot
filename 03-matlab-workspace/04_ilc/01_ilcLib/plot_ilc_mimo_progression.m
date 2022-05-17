function [fig] = plot_ilc_mimo_progression(ilc_data, constraints, legendSteps)
%plot simulation results of mimo ilc 
%   error norm progressions (pitch + position) 
%   output references of every 2nd trial
%   and torques + flyhwheel velocity
if(nargin < 3)
    legendSteps = 2;
end

N = length(ilc_data.r)/2;
t = (0:0.02:(N-1)*0.02)';
% total amount of iterations, including initial iteration
J = length(ilc_data.Uc);

fig = figure;
fig.Position = [20 20 1500 900];
subplot(2,3,1);
plot_error_norm_mimo(ilc_data);
xlabel('trials');
ylabel('euclidean error norm')

% pitch progression
subplot(2,3,2); 
theta_legendCell = cell(1,1);
legendIdx     = 1;
for j=1:legendSteps:J-1
    plot(t, rad2deg(ilc_data.Yc{j}(1:2:end))); hold on;
    idx                         = num2str(j-1);
    theta_legendCell{legendIdx} = append('$\theta_\mathrm{', idx, '}$');
    legendIdx                   = legendIdx + 1;
end
plot(t, rad2deg(ilc_data.Yc{end}(1:2:end)), 'LineWidth', 5); 
plot(t, rad2deg(ilc_data.r(1:2:end)), '--', 'Color', 'black');
idx                                          = num2str(J-1);
theta_legendCell{length(theta_legendCell)+1} = append('$\theta_\mathrm{', idx, '}$');
xlabel('time [s]');
xlim([0 max(t)]);
ylabel('pitch [$^\circ$]');
legend(theta_legendCell, 'Location', 'sw');
title('pitch trajectory progression');

% position progression
subplot(2,3,3);
s_legendCell = cell(1,1);
legendIdx    = 1;
for j=1:legendSteps:J-1
    plot(t, ilc_data.Yc{j}(2:2:end)); hold on;
    idx                       = num2str(j-1);
    s_legendCell{legendIdx}   = append('$s_\mathrm{', idx, '}$');
    legendIdx                 = legendIdx + 1;
end
plot(t, ilc_data.Yc{end}(2:2:end), 'LineWidth', 5); hold on;
idx                                  = num2str(J-1);
s_legendCell{length(s_legendCell)+1} = append('$s_\mathrm{', idx, '}$');
plot(t, ilc_data.r(2:2:end), '--', 'Color', 'black');
xlabel('time [s]');
xlim([0 max(t)]);
ylabel('position [m]');
xlim([0 max(t)]);
legend(s_legendCell, 'Location', 'nw');
title('position trajectory progression');

% tires torque progression
subplot(2,3,4);
uT_legendCell = cell(1,1);
legendIdx     = 1;
for j=1:legendSteps:J-1
    plot(t, ilc_data.Uc{j}(1:2:end)); hold on;
    idx                       = num2str(j-1);
    uT_legendCell{legendIdx}  = append('$u_\mathrm{T,', idx, '}$');
    legendIdx                 = legendIdx + 1;
end
plot(t, (ilc_data.Uc{end}(1:2:end)), 'LineWidth', 5); hold on;
idx                                    = num2str(J-1);
uT_legendCell{length(uT_legendCell)+1} = append('$u_\mathrm{T,', idx, '}$');
ylim([-2.2 2.2]);
yline(constraints.tiresTorqueMax, '--k', 'LineWidth', 3);
yline(-constraints.tiresTorqueMax, '--k', 'LineWidth', 3);
xlabel('time [s]');
xlim([0 max(t)]);
ylabel('torque [Nm]');
legend(uT_legendCell, 'Location', 'nw');
title('tires torque progression');

% flywheel torque progression
subplot(2,3,5);
uF_legendCell = cell(1,1);
legendIdx     = 1;
for j=1:legendSteps:J-1
    plot(t, ilc_data.Uc{j}(2:2:end)); hold on;
    idx                       = num2str(j-1);
    uF_legendCell{legendIdx}  = append('$u_\mathrm{F,', idx, '}$');
    legendIdx                 = legendIdx + 1;
end
plot(t, (ilc_data.Uc{end}(2:2:end)), 'LineWidth', 5); hold on;
idx                                    = num2str(J-1);
uF_legendCell{length(uF_legendCell)+1} = append('$u_\mathrm{F,', idx, '}$');
ylim([-3.3 3.3]);
yline(constraints.flywheelTorqueMax, '--k', 'LineWidth', 3);
yline(-constraints.flywheelTorqueMax, '--k', 'LineWidth', 3);
xlabel('time [s]');
xlim([0 max(t)]);
ylabel('torque [Nm]');
legend(uF_legendCell, 'Location', 'nw');
title('flywheel torque progression');

% flywheel velocity progression
subplot(2,3,6);
psiD_legendCell = cell(1,1);
legendIdx       = 1;
for j=1:legendSteps:J-1
    plot(t, ilc_data.X{j}(:,5)); hold on;
    idx                         = num2str(j-1);
    psiD_legendCell{legendIdx}  = append('$\dot{\psi}_\mathrm{', idx, '}$');
    legendIdx                   = legendIdx + 1;
end
plot(t, ilc_data.X{end}(:,5), 'LineWidth', 5); hold on;
idx                                        = num2str(J-1);
psiD_legendCell{length(psiD_legendCell)+1} = append('$\dot{\psi}_\mathrm{', idx, '}$');
yline(constraints.flywheelVelocityMax, '--k', 'LineWidth', 3);
yline(-constraints.flywheelVelocityMax, '--k', 'LineWidth', 3);
xlabel('time [s]');
xlim([0 max(t)]);
ylabel('velocity [$\frac{rad}{sec}$]');
legend({'$\dot{\psi}$'}, 'Location', 'nw');
legend(psiD_legendCell, 'Location', 'nw');
title('flywheel velocity progression');
end