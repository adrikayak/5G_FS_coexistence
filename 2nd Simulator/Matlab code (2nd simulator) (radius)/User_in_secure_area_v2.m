function [flag] = User_in_secure_area_v2(index, flag)
%UNTITLED2 Summary of this function goes here
%   Variable 'flag1' indicates whether the user lying within the secure area
%   must be allocated to another BS (yes(1) or no(0)). Variable 'flag2' indicates how many auxiliary antennas in the BS at the back of the FS are already
%   serving users lying in the secure area ( no one(0) just the first one(1) or).

global FS
global BS
global security_angle
global security_circle_radius
global UE_sensibility
global n
global a
global users

user = zeros(1,3);
user(:) = users(index, n, :);

v1 = FS(1, [1 2]) - BS(index, [1 2]);  %Vector joining BS and FS
v2 = user([1 2]) - BS(index, [1 2]); %Vector joining BS and UE
angle = rad2deg(acos(dot(v1,v2)/(norm(v1) * norm(v2)))); %Angle (deg) formed by v1 and v2

if angle <= security_angle/2 & user(1)^2 + user(2)^2 < security_circle_radius(a)^2   %if(user lies in the secure area)
    figure(1)       
	plot(user(1), user(2),'ob','MarkerSize', 2, 'MarkerFaceColor', [0 0 1])
        
    if flag == 0
        BS(1, [4 5 6]) = user;  %User allocated to the first auxiliary antenna
        BS(1, 7) = power_control(BS(1,[1 2 3]), BS(1,[4 5 6]), UE_sensibility);
        flag = 1;  %One auxiliary antenna occupied        
    else
        BS(2, [4 5 6]) = user;  %User allocated to the second auxiliary antenna
        BS(2, 7) = power_control(BS(2,[1 2 3]), BS(2,[4 5 6]), UE_sensibility);
        flag = 2;  %Two auxiliary antenna occupied
    end

    BS(index, [4 5 6]) = inf;
end
end

