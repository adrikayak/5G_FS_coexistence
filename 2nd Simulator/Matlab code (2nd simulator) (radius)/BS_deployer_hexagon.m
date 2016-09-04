function [ BS ] = BS_deployer_hexagon(x_first_bs, y_first_bs, radius) 

global h_BS

BS([1 2]) = [x_first_bs y_first_bs];     
BS(3) = [BS(1,1) + sqrt(3)*radius/2 , BS(1,2) - 3* radius/2];        
BS(4) = [BS(1,1) - sqrt(3)*radius/2 , BS(1,2) - 3* radius/2];
BS(:,3) = h_BS;

end


 
 
 
