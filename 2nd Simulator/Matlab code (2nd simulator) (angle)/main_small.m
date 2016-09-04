
close all
clear all

%Global variables
global f
global BS_antenna_pattern
global security_angle
global h_UE
global h_BS
global UE_sensibility
global FS
global BS
global radius
global m


f = 15e9;           %Frequency in Hz

BW = 40;    %System bandwidth in MHz

BS_max_gain = 40;
BS_antenna_pattern = beamforming_BS(BS_max_gain);
security_angle = 30;

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

radius = [200 100 50 20];
distance_to_FS = 5;

FS_interference = zeros(length(radius), 2);
BS_TXpower = zeros(1,2);

for m = 1:length(radius)
for secure_area = 0:1   %Runs two simulations for the SA deactivated and activated respectively
    
    %% Obtains a matrix with information about BSs. Different rows indicate different BSs. Different columns indicate different BSs details: [1 2 3] -> (x,y,z) location, [4] -> operating mode (UL(1) or DL(2))
    BS = zeros(4,7);        
    BS(1,[1 2]) = [0, radius(m)];   
    BS(2,[1 2]) = [0, radius(m)];
    BS(3, [1 2]) = [BS(1,1) + sqrt(3)*radius(m)/2 , BS(1,2) - 3* radius(m)/2];        
    BS(4, [1 2]) = [BS(1,1) - sqrt(3)*radius(m)/2 , BS(1,2) - 3* radius(m)/2];
    BS(:,3) = h_BS;
    
    plot_deployment()
    
    %% Allocates a UEs that will be served by the BSs and the power that will be transmitted in case of DL
    
    BS(3, [4 5 6]) = [5 -5 h_UE];  %Allocates one UE to serve
    BS(4, [4 5 6]) = [-5 -5 h_UE];  %Allocates one UE to serve
    
    plot(BS(3, 4), BS(3, 5), 'or','MarkerSize', 2, 'MarkerFaceColor', [1 0 0]);
    plot(BS(4, 4), BS(4, 5), 'or','MarkerSize', 2, 'MarkerFaceColor', [1 0 0]);
    
    if secure_area == 0
        BS([1 2], :) = [];
    else
        BS(1, [4 5 6]) = BS(3, [4 5 6]);
        BS(1, [4 5 6]) = BS(4, [4 5 6]);
        BS([3 4], :) = [];
    end

    for i = 1:size(BS,1)
        BS(i,7) = power_control(BS(i,[1 2 3]), BS(i, [4 5 6]), UE_sensibility);        
    end
    %% Calculates the angles between entities
    BS_to_FS_angles = zeros(size(BS,1), 4);

    for i = 1:size(BS,1)

            [BS_to_FS_angles(i,1), BS_to_FS_angles(i,2), BS_to_FS_angles(i,3), BS_to_FS_angles(i,4)] = angles_calculator(BS(i,[1 2 3]), BS(i, [5 6 7]), FS, FS_sender); 

    end

    BS_to_FS_angles = round(BS_to_FS_angles);
        
    %% Calculates interferences
    FS_interference_aux = 0;        

    for i = 1:size(BS,1)
            FS_interference_aux = FS_interference_aux + 10^((BS(i,7) - path_loss(BS(i,[1 2 3]), FS(1,:)) + BS_antenna_pattern(BS_to_FS_angles(i,1) + 1, BS_to_FS_angles(i,2) + 1) + FS_antenna_pattern(BS_to_FS_angles(i,3) + 1, BS_to_FS_angles(i,4) + 1))/10);
    end

    FS_interference(m,secure_area + 1) = 10 * log10(FS_interference_aux);       

end
end


figure
bar(FS_interference)
set(gca,'XTickLabel',{['radius = ' num2str(radius(1))], ['radius = ' num2str(radius(2))], ['radius = ' num2str(radius(3))], ['radius = ' num2str(radius(4))]})
legend('No SA', 'SA')
title('FS interference')
% legend(['R = ', num2str(radius(1)), '-- No SA'], ['R = ', num2str(radius(1)), ' -- SA'], ['R = ', num2str(radius(2)), ' -- No SA'], ['R = ', num2str(radius(2)), ' -- SA'], ['R = ', num2str(radius(3)), ' -- No SA'], ['R = ', num2str(radius(3)), '-- SA'], 'I_{thr}/per MHz')
