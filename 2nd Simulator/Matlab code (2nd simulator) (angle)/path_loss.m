function [ PL ] = path_loss(point1, point2)
%PATH LOSS Calculates the pathloss between two points.
%   This function calculates the path loss between two 3D points, in dBs.
%   Frequency is defined as global
%   

global f

d = distance_calculator(point1, point2);
lambda = 3e8/f;
PL = 40 * log10(4 * pi * d / lambda);

end

