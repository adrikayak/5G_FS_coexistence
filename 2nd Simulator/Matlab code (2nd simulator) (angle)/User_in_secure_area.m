function [ user, flag2 ] = User_in_secure_area(index)
%UNTITLED2 Summary of this function goes here
%   Variable 'flag1' indicates whether the user lying within the secure area
%   must be allocated to another BS (yes(1) or no(0)). Variable 'flag2' indicates how many auxiliary antennas in the BS at the back of the FS are already
%   serving users lying in the secure area ( no one(0) just the first one(1) or).

global FS
global BS
global security_angle
global BS_at_the_back_of_FS
global h_UE
global UE_sensibility

user = BS(index, [5 6 7]);

v1 = FS(1, [1 2]) - BS(index, [1 2]);  %Vector joining BS and FS
v2 = user([1 2]) - BS(index, [1 2]); %Vector joining BS and UE
angle = rad2deg(acos(dot(v1,v2)/(norm(v1) * norm(v2)))); %Angle (deg) formed by v1 and v2

if angle <= security_angle/2   %if(user lies in the secure area)
    if flag1 & flag2 ~= 2   %if(the user can be alocated to the auxiliary antenna & there is at least one free auxiliary antenna)
        
       figure(1)       
       plot(user(1), user(2),'ob','MarkerSize', 2, 'MarkerFaceColor', [0 0 1])
        
        if flag2 == 0
            BS(BS_at_the_back_of_FS + 1, [5 6 7]) = user;  %User allocated to the first auxiliary antenna
            BS(BS_at_the_back_of_FS + 1, 8) = power_control(BS(BS_at_the_back_of_FS + 1,[1 2 3]), BS(BS_at_the_back_of_FS + 1,[5 6 7]), UE_sensibility);
            flag2 = 1;  %One auxiliary antenna occupied
        else
            BS(BS_at_the_back_of_FS + 2, [5 6 7]) = user;  %User allocated to the first auxiliary antenna
            BS(BS_at_the_back_of_FS + 2, 8) = power_control(BS(BS_at_the_back_of_FS + 2,[1 2 3]), BS(BS_at_the_back_of_FS + 2,[5 6 7]), UE_sensibility);
            flag2 = 2;  %Two auxiliary antennas occupied
        end

        BS(index, [5 6 7]) = [User_in_this_cell(BS(index, [1 2])), h_UE];
        BS(index, [5 6 7]) = User_in_secure_area(index, 0, flag2);

    else
        BS(index, [5 6 7]) = [User_in_this_cell(BS(index, [1 2])), h_UE];
        BS(index, [5 6 7]) = User_in_secure_area(index, 0, flag2);
    end
end

user = BS(index, [5 6 7]);

end

