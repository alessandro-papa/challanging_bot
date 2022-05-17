function plotTrajectoriesOverTime_mimo(t, pitch, position)
    subplot(2,1,1);
    plot(t, pitch); hold on;
    xlabel('time [s]');
    ylabel('pitch [rad]');
    subplot(2,1,2);
    plot(t, position); hold on;
    xlabel('time [s]');
    ylabel('position [m]');
end

