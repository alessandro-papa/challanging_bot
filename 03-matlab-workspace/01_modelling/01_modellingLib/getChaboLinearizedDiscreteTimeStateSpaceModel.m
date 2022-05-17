function [chabo_ol_lin_disc, constraints] = getChaboLinearizedDiscreteTimeStateSpaceModel()
%GETCHABOLINEARIZEDDISCRETETIMEMODEL 
%   Detailed explanation goes here
% load model from .mat file
load('chabo_ol_dynamics_disc.mat');
chabo_ol_lin_disc   = chabo_ol_disc;
constraints         = constraints;
end

