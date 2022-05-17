function [X,U] = sim_lqr_lin(chabo_ol_disc_model,Kd,x0,N)
%SIM_LQR simulate lqr experiment of chabo
%   Detailed explanation goes here
% initialise params to pre-allocate memory 
X = zeros(5, N);
U = zeros(2, N);
x = x0;
    for n = 1:N
        % compute Torque
        u = -Kd*x;
        % Save Values
        X(:, n) = x;
        U(:, n) = u;
        % Dynamics
        x = chabo_ol_disc_model.A*x + chabo_ol_disc_model.B*u;
    end
end

