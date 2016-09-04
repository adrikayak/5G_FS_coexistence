
close all
clear all

%Global variables
global f
global BS_antenna_pattern
global security_angle
global security_circle_radius
global h_UE
global h_BS
global UE_sensibility
global FS
global BS
global radius
global m
global n
global a
global users

f = 15e9;           %Frequency in Hz

BW = 40;    %System bandwidth in MHz

BS_max_gain = 40;
BS_antenna_pattern = beamforming_BS(BS_max_gain);

security_angle = 40;


FS_max_gain = 60;
FS_antenna_pattern = beamforming_FS(FS_max_gain); 

BS_TXpower_threshold = 17;
UE_sensibility_per_MHz = -116; %Sensibility 
BS_interference_threshold_per_MHz = -118;
FS_interference_threshold_per_MHz = -118;

UE_sensibility = 10 * log10(10^(UE_sensibility_per_MHz/10) * BW);
BS_interference_threshold = 10 * log10(10^(BS_interference_threshold_per_MHz/10) * BW);
FS_interference_threshold = 10 * log10(10^(FS_interference_threshold_per_MHz/10) * BW);

h_UE = 1.7; %UEs height in meters
h_BS = 6;   %BSs height in meters
h_FS = 20;  %FSs height in meters

FS_length = 800;    %FS link distance in meters
FS = [0 0 h_FS];
FS_sender = [0 -FS_length h_FS];

radius = [200];
security_circle_radius = linspace(0,1,5) * radius;
colors = jet(length(security_circle_radius));
% colors = [0 0 1; 1 0 0];

timeslots = 1000;

FS_interference = zeros(length(security_circle_radius), timeslots);
BS_TXpower = cell(length(security_circle_radius), timeslots);


for m = 1:length(radius) 

    
    %% Obtains a matrix with information about BSs. Different rows indicate different BSs. Different columns indicate different BSs details: [1 2 3] -> (x,y,z) location, [4] -> operating mode (UL(1) or DL(2))
    BS = zeros(4,7);        
    BS(1,[1 2]) = [0, radius(m)];   
    BS(2,[1 2]) = [0, radius(m)];
    BS(3, [1 2]) = [BS(1,1) + sqrt(3)*radius(m)/2 , BS(1,2) - 3* radius(m)/2];        
    BS(4, [1 2]) = [BS(1,1) - sqrt(3)*radius(m)/2 , BS(1,2) - 3* radius(m)/2];
    BS(:,3) = h_BS;
    
    users = zeros(2, timeslots, 3);
    users([1 2], :, :) = inf;
    
    for i = 3:size(BS,1)
        for j = 1:timeslots
            users(i, j, [1 2 3]) = [User_in_this_cell_v2(BS(i, [1 2])), h_UE];
        end
    end


    
for a = 1:length(security_circle_radius)
    plot_deployment()
    for n = 1:timeslots        
    %% Allocates UEs that will be served by the BSs and the power that will be transmitted in case of DL
    flag = 0;
    for i = 1:size(BS,1)        
        BS(i, [4 5 6]) = users(i,n,:);	%Allocates one UE to serve
        if any(i == [3 4])
            plot(BS(i,4), BS(i,5), 'o','MarkerSize', 2, 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0])   %Plot the user
        	User_in_secure_area_v2(i, flag);
        end
    end

    for i = 1:size(BS,1)
        
        if ~any(BS(i, [5 6 7]) == inf)
            BS(i,7) = power_control(BS(i,[1 2 3]), BS(i, [4 5 6]), UE_sensibility);
        else
            BS(i,7) = -inf;
        end
    end
    
    %% Calculates the angles between BSs and FS
    BS_to_FS_angles = zeros(size(BS,1), 4);

    for i = 1:size(BS,1)
        if ~any(BS(i,[4 5 6]) == inf)
            [BS_to_FS_angles(i,1), BS_to_FS_angles(i,2), BS_to_FS_angles(i,3), BS_to_FS_angles(i,4)] = angles_calculator(BS(i,[1 2 3]), BS(i, [4 5 6]), FS, FS_sender); 
        else
            BS_to_FS_angles(i,:) = 0;
        end
    end

    BS_to_FS_angles = round(BS_to_FS_angles);
        
    %% Calculates interferences
    FS_interference_aux = 0;        

    for i = 1:size(BS,1)
        if ~any(BS(i,[4 5 6]) == inf)
            FS_interference_aux = FS_interference_aux + 10^((BS(i,7) - path_loss(BS(i,[1 2 3]), FS(1,:)) + BS_antenna_pattern(BS_to_FS_angles(i,1) + 1, BS_to_FS_angles(i,2) + 1) + FS_antenna_pattern(BS_to_FS_angles(i,3) + 1, BS_to_FS_angles(i,4) + 1))/10);
        end
    end

    FS_interference(a, n) = 10 * log10(FS_interference_aux);
    
    %% Calculate BS_Txpower
    
    BS_TXpower_aux = [];        
    BS_TXpower_aux = BS(BS(:,7) ~= -inf,7);
    BS_TXpower{a,n} = BS_TXpower_aux;

    end
    
    figure(2)
    [y, x] = ecdf(FS_interference(a, :));
    hold on
    plot(x, y, 'Color', colors(a,:), 'LineWidth',2)

    
    figure(3)
    [y, x] = ecdf(cell2mat(BS_TXpower(a,:)'));
    hold on
	plot(x, y, 'Color', colors(a,:), 'LineWidth',2)
    
    figure(1)
    hold off
end

figure(2)
title(['FS interference for R = ' num2str(radius(m)) ' and SA_{angle} = ' num2str(security_angle)], 'FontSize', 14, 'FontWeight', 'bold')
xlabel('Interference level in dBm', 'FontSize', 14, 'FontWeight', 'bold')
ylabel('Percentage of timeslots under a certain interference level', 'FontSize', 14, 'FontWeight', 'bold')
legend('SA deactivated', ['SA_{circle radius} = ' num2str(security_circle_radius(2))] , ['SA_{circle radius} = ' num2str(security_circle_radius(3))], ['SA_{circle radius} = ' num2str(security_circle_radius(4))], ['SA_{circle radius} = ' num2str(security_circle_radius(5))])
% legend('SA deactivated', ['SA_{circle radius} = ' num2str(security_circle_radius(2))])
% saveas(h, 'FS_interference.jpg')

figure(3)
title(['BS Tx power for R = ' num2str(radius(m)) ' and SA_{angle} = ' num2str(security_angle)], 'FontSize', 14, 'FontWeight', 'bold')
xlabel('Tx power in dBm', 'FontSize', 14, 'FontWeight', 'bold')
ylabel('Percentage of timeslots under a certain Tx power', 'FontSize', 14, 'FontWeight', 'bold')
legend('SA deactivated', ['SA_{circle radius} = ' num2str(security_circle_radius(2))] , ['SA_{circle radius} = ' num2str(security_circle_radius(3))], ['SA_{circle radius} = ' num2str(security_circle_radius(4))], ['SA_{circle radius} = ' num2str(security_circle_radius(5))])
% legend('SA deactivated', ['SA_{circle radius} = ' num2str(security_circle_radius(2))])
% saveas(h, 'BS_Txpower.jpg')

end

