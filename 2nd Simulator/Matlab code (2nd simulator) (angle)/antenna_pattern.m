function [gain3] = antenna_pattern(max_gain)

N=10;
c=3e8;
f=15e9;
d = c/f;
k0=2*pi/d;
gain=zeros(180,180);

for phi=pi/180:pi/180:pi;
    for theta=pi/180:pi/180:pi;
        Se1=cos(theta)*cos(theta);
        Se2=cos(phi)*cos(phi);
        Se=Se1*Se2;
        Sa=0;
        Sat=(sin(N*sin(theta)*sin(phi)*k0*d/2)*sin(N*sin(theta)*cos(phi)*k0*d/2))/(sin(sin(theta)*sin(phi)*k0*d/2)*sin(sin(theta)*cos(phi)*k0*d/2));
        x=round(phi*180/pi);
        y=round(theta*180/pi);
        gain(x,y)=abs(Se)*abs(Sat);
    end
end
gain;
gain2= zeros(180,180);
for i =1:1:180;
    for j=1:1:180;
        if i > 90
            w1 = 1-(i-90)/90;
        else
            w1 =1;
        end
        if j > 90
            w2 = 1-(j-90)/90;
        else
            w2 =1;
        end
        gain2(i,j)=w1*w2*gain(1,i)*gain(1,j)/(N*N);
    end
end
x = 1:size(gain2,1);
y = 1:size(gain2,2);
[X,Y] = meshgrid(x,y);
gain3=gain2/(N*N);
gain3 = gain3 * max_gain;
% gain3(2:end,2:end) = gain3(2:end,2:end)/100;
% gain3 = gain3 * 10000;
surf(X,Y,gain3);

end

