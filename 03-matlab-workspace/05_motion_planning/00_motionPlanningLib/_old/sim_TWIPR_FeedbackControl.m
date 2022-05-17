function [pitch_traj, position_traj] = sim_TWIPR_FeedbackControl(pitch_ref, position_ref)
    % Setup
    N = length(pitch_ref);
    T = 0.02;
    pitch_traj    = zeros(N, 1);
    position_traj = zeros(N,1);
    x = zeros(4,1);
    load('1_Data\twipr_ol_dynamics.mat');
    K = dlqr(A, B, diag([0.5, 1, 10, 0]), 0.05);
    V = -1/0.231;
    
    for n = 1:N
        u = -K*x + position_ref(n)*V;
        x = A*x  + B*u;
        pitch_traj(n)    = x(1);
        position_traj(n) = x(3);
    end
end

