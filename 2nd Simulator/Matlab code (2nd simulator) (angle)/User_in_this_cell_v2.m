function [ user ] = User_in_this_cell_v2(BS)

global radius
global m

flag = 0;
figure(1)
hold on

while flag ~= 1
    
   user = 2*radius(m)*rand(1,2)-1*radius(m);
   
   if (abs(user(2)) + abs(user(1))/sqrt(3) ) <= radius(m) && abs(user(1)) <= radius(m)*sqrt(3)/2

        flag = 1;      
%         plot(user(1) + BS(1), user(2) + BS(2), 'or','MarkerSize', 2, 'MarkerFaceColor', [1 0 0]);     
        user = [user(1) + BS(1) user(2) + BS(2)];
    
   end

end
end

