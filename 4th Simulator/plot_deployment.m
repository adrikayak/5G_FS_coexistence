function [  ] = plot_deployment(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global BS
global FS
global radius
global m
global area_of_interest

up_border = area_of_interest/2 + radius(m);
down_border = -area_of_interest/2 - radius(m);
left_border = -area_of_interest/2 - radius(m);
right_border = area_of_interest/2 + radius(m);

figure(1)
plot(BS(:,1), BS(:,2),'og','MarkerSize',3,'MarkerFaceColor',[0 1 0]);
xlabel('X','FontName','Times New Roman','FontSize',14)
ylabel('Y','FontName','Times New Roman','FontSize',14)
axis([left_border right_border down_border up_border]);
hold on
N = radius(m);

for i = 1:size(BS,1)
    
    A = [BS(i,1) BS(i,2)];
    B = [A(1) A(1) + N*sqrt(3)/2 A(1)+N*sqrt(3)/2 A(1) A(1)-N*sqrt(3)/2 A(1)-N*sqrt(3)/2 A(1)];
    C = [A(2)+N A(2)+N/2 A(2)-N/2 A(2)-N A(2)-N/2 A(2)+N/2 A(2)+N];
    plot(B,C,'b','LineWidth',2)
    
end

B =[-area_of_interest/2 -area_of_interest/2 area_of_interest/2 area_of_interest/2 -area_of_interest/2];
C =[-area_of_interest/2 area_of_interest/2 area_of_interest/2 -area_of_interest/2 -area_of_interest/2];
plot(B,C,'g--','LineWidth',2)

plot(FS(:,1),FS(:,2),'ko','LineWidth',3)

end

