function [ neighbour ] = neighbour_checker( right_border, left_border, up_border, down_border, neighbour, position_BS )
%Checks whether the new neighbor is already deployed as a BS and whether it lies within
%the area of interest + radius
%   Detailed explanation goes here

        
        if (neighbour(1) <= right_border) & (neighbour(1) >= left_border) & ( neighbour(2) <= up_border) & ( neighbour(2) >= down_border)
            
            a = size(position_BS,1);
            exist = [];
            
            for j = 1:a
                
                exist(j) = (fix(neighbour(1)) == fix(position_BS(j,1))) & (fix(neighbour(2)) == fix(position_BS(j,2)));
            
            end
            
            if exist == zeros(1,a)
                
            else                
                neighbour = [];                
            end
            
        else
            neighbour = [];
        end
        
        

end

