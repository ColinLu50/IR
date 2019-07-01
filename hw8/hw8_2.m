function hw8_2()
    
clc;clear;
close all;

figure(1) % figure(2) you should generate sample base on figure(1)
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
hold on
mu=0;
sigma_r=15;
sigma_theta = 1;
landmark_num = 6;
pos = [300 200 0];
xc=[0 300 600 600 300 0] ;
yc=[0 0 0 400 400 400];
r = [360 200 360 360 200 360];
circle = [ 0 pi/2;
           0  pi;
           pi/2 pi;
           -pi/2 -pi;
           0 -pi;
           0 -pi/2
            ];
N = 100;
sample_x = [];
sample_y = [];
sample_theta = [];
for k = 1:6
x1 = zeros(1,N);
y1 = zeros(1,N);
theta1 = zeros(1,N);
t= linspace(circle(k,1),circle(k,2),N);
for i = 1:N
    r_tmp = r(k) + normrnd(mu, sigma_r);
    x1(i) = r_tmp * cos(t(i)) + xc(k);
    y1(i) = r_tmp * sin(t(i)) + yc(k);
    cur_theta = pos(3) + normrnd(0, sigma_theta);
    cur_theta = mod(cur_theta,2*pi);
    if cur_theta > pi
        cur_theta = cur_theta - 2*pi;
    end
    theta1(i) = cur_theta;
    circleplot(x1(i),y1(i),5,theta1(i));
end


circleplot(pos(1),pos(2),20,pos(3));
% plot(x1, y1, '.');
plot(xc(k), yc(k),'or','LineWidth',10);
sample_x = [sample_x x1];
sample_y = [sample_y y1];
sample_theta = [sample_theta theta1];
end

circleplot_robot(pos(1),pos(2),20,pos(3)); % drawing the robot

% ========== resample ===========
figure(2)
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);



actual_d = zeros(1, landmark_num);
for k = 1:landmark_num
    actual_d(k) = norm(pos(1:2) - [xc(k) yc(k)]);
end


all_len = length(sample_x);
w = zeros(1,all_len);
w_sum = 0;
for i = 1:all_len
    w(i) = landmark_detection_model(sample_x(i), sample_y(i), sample_theta(i));
    w_sum = w_sum + w(i);   
end
w = w./w_sum;

resample_x = zeros(1,all_len);
resample_y = zeros(1,all_len);
resample_theta = zeros(1,all_len);
next_w = zeros(1,all_len);
for m = 1: 5
    cum_w = cumsum(w);
    for i = 1:all_len
        tmp = rand;
        j = 1;
        while cum_w(j) < tmp
            j = j + 1;
        end
        resample_x(i) = sample_x(j);
        resample_y(i) = sample_y(j);
        resample_theta(i) = sample_theta(j);
        next_w(i) = w(i); 
    end
    w = next_w;
    w = w./sum(w);
    sample_x = resample_x;
    sample_y = resample_y;
    sample_theta = resample_theta;
%     all_len = floor(all_len / 5);

end
% plot(resample_x, resample_y, '.');
for i = 1:all_len
    circleplot(resample_x(i), resample_y(i),5,resample_theta(i));
end

m = mean(resample_x);
n = mean(resample_y);
theta = mean(resample_theta);
circleplot_robot(m,n,20,theta);






function p = landmark_detection_model(s_x, s_y, s_theta)
     p = 1;
    for c = 1:landmark_num
        s_d = norm([s_x s_y] - [xc(c) yc(c)]);
        p = p * normpdf(s_d - actual_d(c), 0, 60) * normpdf(pos(3) - s_theta, 0, 5);
    end
    
    
end






end

function circleplot_robot(xc, yc, r, theta)
t = 0 : .01 : 2*pi;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y, 'r','LineWidth',2)
t2 = 0 : .01 : r;
x = t2 * cos(theta) + xc;
y = t2 * sin(theta) + yc;
plot(x, y, 'r', 'LineWidth',2)
end

function circleplot(xc, yc, r, theta)
t = 0 : .01 : 2*pi;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y,'LineWidth',0.1)
t2 = 0 : .01 : r;
x = t2 * cos(theta) + xc;
y = t2 * sin(theta) + yc;
plot(x, y,'LineWidth',0.1)
end