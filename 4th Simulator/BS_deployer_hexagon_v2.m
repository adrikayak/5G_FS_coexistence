function [ BS ] = BS_deployer_hexagon_v2(x_first_bs, y_first_bs, h_BS, area_of_interest, FS ) 

global radius
global m

up_border_area_of_interest = area_of_interest/2 + radius(m);
down_border_area_of_interest = -area_of_interest/2 - radius(m);
left_border_area_of_interest = -area_of_interest/2 - radius(m);
right_border_area_of_interest = area_of_interest/2 + radius(m);

position_BS=[];

new_BS_add = true;

position_BS = [position_BS; [x_first_bs y_first_bs]];

index = 0;

while new_BS_add == true
    
    new_neighbour =[];
    
    for i = index + 1:size(position_BS,1)
        
        neighbour = [position_BS(i,1) + sqrt(3)*radius(m) , position_BS(i,2)];
        new_neighbour = [new_neighbour; neighbour_checker(right_border_area_of_interest, left_border_area_of_interest, up_border_area_of_interest, down_border_area_of_interest, neighbour, position_BS)];
        
        neighbour = [position_BS(i,1) + sqrt(3)*radius(m)/2 , position_BS(i,2) - 3* radius(m)/2];
        new_neighbour = [new_neighbour; neighbour_checker(right_border_area_of_interest, left_border_area_of_interest, up_border_area_of_interest, down_border_area_of_interest, neighbour, position_BS)];
        
        neighbour = [position_BS(i,1) - sqrt(3)*radius(m)/2 , position_BS(i,2) - 3* radius(m)/2];
        new_neighbour = [new_neighbour; neighbour_checker(right_border_area_of_interest, left_border_area_of_interest, up_border_area_of_interest, down_border_area_of_interest, neighbour, position_BS)];
        
        neighbour = [position_BS(i,1) - sqrt(3)*radius(m) , position_BS(i,2)];
        new_neighbour = [new_neighbour; neighbour_checker(right_border_area_of_interest, left_border_area_of_interest, up_border_area_of_interest, down_border_area_of_interest, neighbour, position_BS)]; 
        
        neighbour = [position_BS(i,1) - sqrt(3)*radius(m)/2 , position_BS(i,2) + 3* radius(m)/2];
        new_neighbour = [new_neighbour; neighbour_checker(right_border_area_of_interest, left_border_area_of_interest, up_border_area_of_interest, down_border_area_of_interest, neighbour, position_BS)];
           
        neighbour = [position_BS(i,1) + sqrt(3)*radius(m)/2 , position_BS(i,2) + 3* radius(m)/2];
        new_neighbour = [new_neighbour; neighbour_checker(right_border_area_of_interest, left_border_area_of_interest, up_border_area_of_interest, down_border_area_of_interest, neighbour, position_BS)];
                   
    end
    
    index = size(position_BS,1);
    
    numx = size(new_neighbour,1);
    
    u_new_BS = [];
    
    if numx > 0
        
        for i = 1:numx-1
            for j = i+1:numx
                if fix(new_neighbour(j,:)) == fix(new_neighbour(i,:))
                    new_neighbour(j,:) = inf;
                end
            end
        end
        
        for i = 1:numx
            if (new_neighbour(i,1) < inf) & (new_neighbour(i,2) < inf)
                u_new_BS=[u_new_BS; new_neighbour(i,:)];
            end
        end
    end
    
    numy = size(u_new_BS,1);
    
    if numy ==0
        new_BS_add = false;
    else
        position_BS = [position_BS; u_new_BS];
    end
                
end
%%
BS = position_BS;
BS(:,3) = h_BS;
BS(:,4) = round(rand(1,size(BS,1)) + 1);   %Set the BSs randomly to start either at UL (1) or DL (2) mode.

end


 
 
 
