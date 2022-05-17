function animate_movement_real_world(real_world, pitch_traj, position_traj)
    figure('Position', [0, 0, 700, 220]);
    real_world.drawWorld();
    for n = 1:length(pitch_traj)
        if(n>1)
            twipr = plotObs{1};
            twipr.FaceAlpha = 0.1;
            twipr.HoleEdgeAlpha = 0.1;
            twipr.EdgeAlpha = 0.1;
            w = plotObs{2};
            w.LineWidth = 0.1;
        end
        plotObs = real_world.drawRealTWIPR(pitch_traj(n), position_traj(n), 'blue');
        drawnow limitrate;
        pause(0.02);

    end
    real_world.drawWorld();
end

