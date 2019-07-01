function hw5_2()

x = 0;
y = 0;
theta = 0;
t = 2;

a1 = .000005;
a2 = .000005;
a3 = .000007;
a4 = .000005;

trajectory_data = zeros(3,500,30);
odom = zeros(3,30);
odom(:,:) = NaN;
odom(:,1:3)= 0;

trajectory_data(:,:,:) = NaN;
trajectory_data(:,:,1) = 0;

while (t <= 30 )
    
    if t < 10
        delta_rot1 = 0;
        delta_trans =50;
        delta_rot2 = 0;
    elseif (t >= 10)&&(t < 12)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = pi/4;
    elseif (t >= 12)&&(t < 20)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = 0;
    elseif (t >= 20)&&(t < 22)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = pi/4;
    elseif (t >= 22)&&(t <= 30)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = 0;
    end
    
    
    for n = 1: 500
        % Do your sampling
        delta_rot1_hat = delta_rot1 - sample_norm(a1*delta_rot1^2 + a2 * delta_trans^2);
        delta_trans_hat = delta_trans - sample_norm(a3*delta_trans^2 + a4 * delta_rot1^2 + a4 * delta_rot2^2);
        delta_rot2_hat = delta_rot2 - sample_norm(a1*delta_rot2^2 + a2 * delta_trans^2);
        
        trajectory_data(1,n,t) = trajectory_data(1,n,t-1) + delta_trans_hat * cos(trajectory_data(3,n,t-1) + delta_rot1_hat);
        trajectory_data(2,n,t) = trajectory_data(2,n,t-1) + delta_trans_hat * sin(trajectory_data(3,n,t-1) + delta_rot1_hat);
        trajectory_data(3,n,t) = trajectory_data(3,n,t-1) + delta_rot1_hat + delta_rot2_hat;
        n = n + 1;
    end
    
    
    
    if t < 10
        
        delta_rot1 = 0;
        delta_trans =50;
        delta_rot2 = 0;
        
        odom(1,t) = odom(1,t-1) + delta_trans;
        
        odom(2,t) = odom(2,t-1);
        
        odom(3,t) = odom(3,t-1) + delta_rot1 + delta_rot2;
    elseif (t >= 10)&&(t < 12)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = pi/4;
        
        odom(1,t) = odom(1,t-1) + delta_trans * cos(odom(3,t-1) + delta_rot1);
        odom(2,t) = odom(2,t-1) + delta_trans * sin(odom(3,t-1) + delta_rot1);
        
        odom(3,t) = odom(3,t-1) + delta_rot1 + delta_rot2;
    elseif (t >= 12)&&(t < 20)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = 0;
        odom(1,t) = odom(1,t-1);
        odom(2,t) = odom(2,t-1) + delta_trans;
        
        odom(3,t) = odom(3,t-1) + delta_rot1 + delta_rot2;
    elseif (t >= 20)&&(t < 22)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = pi/4;
        
        odom(1,t) = odom(1,t-1) + delta_trans * cos(odom(3,t-1) + delta_rot1);
        odom(2,t) = odom(2,t-1) + delta_trans * sin(odom(3,t-1) + delta_rot1);
        
        odom(3,t) = odom(3,t-1) + delta_rot1 + delta_rot2;
    elseif (t >= 22)&&(t <= 31)
        delta_rot1 = 0;
        delta_trans = 50;
        delta_rot2 = 0;
        
        odom(1,t) = odom(1,t-1) + delta_trans * cos(-pi);
        odom(2,t) = odom(2,t-1);
        
        odom(3,t) = odom(3,t-1) + delta_rot1 + delta_rot2;
    end
    
    t = t + 1;
    
end

plot(odom(1,:),odom(2,:),'r','LineWidth',1.5);
pause(3);
hold on
for m = 1:30
 scatter(trajectory_data(1,5:500,m),trajectory_data(2,5:500,m),'.');
 pause(1);
 hold on
end


end


function x = sample_norm(b)
x = 0;
for i = 1:12
    x = x + (-b + 2 * b * rand());
end
x = x * 1/2;
end