function [gain3] = beamforming_FS(max_gain_dB)

N=10;
c=300000000;
f=10000000000;
d = c/f;
k0=2*pi/d;
gain=zeros(181,181);

for phi=pi/180:pi/180:pi;
    for theta=pi/180:pi/180:pi;
        Se1=cos(theta)*cos(theta)*cos(theta);
        Se2=cos(phi)*cos(phi)*cos(phi);
        Se=Se1*Se2;
        Sa=0;
        Sat=(sin(N*sin(theta)*sin(phi)*k0*d/2)*sin(N*sin(theta)*cos(phi)*k0*d/2))/(sin(sin(theta)*sin(phi)*k0*d/2)*sin(sin(theta)*cos(phi)*k0*d/2));
        x=round(phi*180/pi);
        y=round(theta*180/pi);
        gain(x,y)=abs(Se)*abs(Sat);
    end
end
gain;
gain2= zeros(181,181);
for i =1:1:181;
    for j=1:1:181;
        if i <7
            w1 = 1-(i)/180;
        else
            w1= (1-(i-2)/180)/100;
        end
        if j < 7
            w2 = 1-(j)/180;
        else
            w2 = (1-(j-2)/180)/100;
        end
        gain2(i,j)=w1*w2*(gain(1,i)*gain(1,j)+10)/(N*N);
    end
end
x = 1:size(gain2,1);
y = 1:size(gain2,2);
[X,Y] = meshgrid(x,y);
gain3=gain2/(N*N);
gain3 = gain3/max(max(gain3));
gain3 = gain3 * 10^((max_gain_dB)/10);
gain3 = 10 * log10(gain3);
% figure
% surf(X,Y,gain3);
% title('FS antenna pattern')
% x1=xlabel('theta');      
% x2=ylabel('phi');        
% x3=zlabel('normalized gain');
end
