function [ power ] = power_control( transmitter, receiver, S)
%POWER_CONTROL Allocates a transmission power
%   This function allocates a transmission power depending on the
%   considered path-loss and the sensibility.
global BS_antenna_pattern

pathloss = path_loss(transmitter, receiver);
power = S + pathloss - max(max(BS_antenna_pattern));
% power = S + pathloss - 0;


end

