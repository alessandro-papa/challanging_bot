function [chabo_ol_lin_cont, constraints] = getChaboLinearizedContinuousTimeStateSpaceModel()
%GETCHABOLINEARIZEDDISCRETETIMEMODEL 
%   Detailed explanation goes here
% load model from .mat file
load('chabo_ol_dynamics_cont.mat');
chabo_ol_lin_cont   = chabo_ol_cont;
constraints         = constraints;
end

