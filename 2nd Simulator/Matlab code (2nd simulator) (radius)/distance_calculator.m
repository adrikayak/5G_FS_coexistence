function [ distance ] = distance_calculator( entities1, entities2 )
%Calculates the distance between every element in entities1 matrix and
%every element in entities2 matrix. entities1 and entities2 matrices
%contain (x,y,z) position of the elements in a (nx3) form, being n the
%number of elements in the matrix. Resulting distance matrix is of the form
%(size(entities1,1) x size(entities2,1)).
%   Detailed explanation goes here

distance = zeros(size(entities1,1),size(entities2,1));

for i = 1:size(entities1,1)
    
    for j = 1:size(entities2,1)
        
        distance(i,j) = sqrt((entities1(i,1) - entities2(j,1))^2 + (entities1(i,2) - entities2(j,2))^2 + (entities1(i,3) - entities2(j,3))^2);       
        
    end


end

