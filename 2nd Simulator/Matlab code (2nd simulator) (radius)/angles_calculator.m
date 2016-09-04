function [phi_c ,theta_c , phi_s ,theta_s ] = angles_calculator(S_sender,S_receiver,I_point,Pair_point)


global h_UE

if S_sender(3) == h_UE %signal sender is a mobile user
    phi_c = 0;
    theta_c = 0;
else
    vector1_h=[];
    vector2_h=[];
    vector1_h(1) = S_receiver(1)-S_sender(1);
    vector1_h(2) = S_receiver(2)-S_sender(2);
    vector2_h(1) = I_point(1)-S_sender(1);
    vector2_h(2) = I_point(2)-S_sender(2);
    if norm(vector1_h)*norm(vector2_h)==0
        phi_c =0;
    else
        phi_c=acos(dot(vector1_h,vector2_h)/(norm(vector1_h)*norm(vector2_h)))*180/pi;
    end
    dis_h1=norm(vector1_h);
    dis_h2=norm(vector2_h);
    vector_h = dis_h2*cos(phi_c*pi/180);
    vector1_v=[];
    vector2_v=[];
    vector1_v(1)=dis_h1;
    vector1_v(2)=S_receiver(3)-S_sender(3);
    vector2_v(1)=vector_h;
    vector2_v(2)=I_point(3)-S_sender(3);
    if norm(vector1_v)*norm(vector2_v)==0
        theta_c =0;
    else
        theta_c = acos(dot(vector1_v,vector2_v)/(norm(vector1_v)*norm(vector2_v)))*180/pi;
    end
end

if I_point(3) == h_UE %the interfence point is a mobile user
    phi_s = 0;
    theta_s = 0;
else
    vector1_h=[];
    vector2_h=[];
    vector1_h(1) = S_sender(1) - I_point(1) ;
    vector1_h(2) = S_sender(2) - I_point(2);
    vector2_h(1) = Pair_point(1) - I_point(1);
    vector2_h(2) = Pair_point(2) - I_point(2);
    
    if norm(vector1_h)*norm(vector2_h)==0
        phi_s =0;
    else
        phi_s = acos(dot(vector1_h,vector2_h)/(norm(vector1_h)*norm(vector2_h)))*180/pi;
    end
    
    dis_h1=norm(vector1_h);
    dis_h2=norm(vector2_h);
    vector_h = dis_h1*cos(phi_s*pi/180);
    
    vector1_v=[];
    vector2_v=[];
    vector1_v(1)=vector_h ;
    vector1_v(2)=S_sender(3)-I_point(3);
    vector2_v(1)=dis_h2;
    vector2_v(2)=Pair_point(3)-I_point(3);
    if norm(vector1_v)*norm(vector2_v)==0
        theta_s =0;
    else
        theta_s = acos(dot(vector1_v,vector2_v)/(norm(vector1_v)*norm(vector2_v)))*180/pi;
    end
    
    
    
end


end

