function [ user ] = User_in_this_cell(BS)

global radius
global m
flag = 0;

while flag == 0
    
   x = 2*radius(m)*rand(1,2)-1*radius(m);
   
   if (abs(x(2)) + abs(x(1))/sqrt(3) ) <= radius(m) && abs(x(1)) <= radius(m)*sqrt(3)/2
       flag = 1;      
%        plot(x(1) + BS(1), x(2) + BS(2), 'or','MarkerSize', 2, 'MarkerFaceColor', [1 0 0]);     
       user = [x(1) + BS(1) x(2) + BS(2)];
       
   end

end

