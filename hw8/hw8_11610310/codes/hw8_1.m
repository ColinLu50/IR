function hw8_1()
clc;clear;
close all;

% figure(1) is already generate

hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
r=250;
xc=300;
yc=0;
t = 0 : .01 : pi;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);
xc=300;
yc=400;
t = 0 : .01 : pi;
x = r * cos(t) + xc;
y = -r * sin(t) + yc;
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);
r=632;
xc=0;
yc=0;
t = 0 : .01 : pi/2;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);


figure(2) % figure(2) you should generate sample base on figure(1)
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
hold on
mu=0;
sigma=10;


xc=[300 300 0] ;
yc=[0 400 0];
r = [250 250 632];
t = 0 : .01 : pi;

len = [length(t) length(t) floor(length(t)/2)];
sample_x = [];
sample_y = [];
for k = 1:3
x1 = zeros(1,len(k));
y1 = zeros(1,len(k));

for i = 1:len(k)
    r_tmp = r(k) + normrnd(mu, sigma);
    if(k == 2)
    x1(i) = r_tmp * cos(t(i)) + xc(k);
    y1(i) = - r_tmp * sin(t(i)) + yc(k);
    else
        x1(i) = r_tmp * cos(t(i)) + xc(k);
    y1(i) =  r_tmp * sin(t(i)) + yc(k);
    end
end

% sample_x{k} = x1;
% sample_y{k} = y1;
sample_x = [sample_x x1];
sample_y = [sample_y y1];

plot(x1, y1, '.');
end

circleplot(530,200,20,pi) % drawing the robot


% ========== resample ===========
figure(3)
hold on
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
% figure(3) implement your resampling algorithm 
pos = [530 200];


actual_d = [0 0 0];
for k = 1:3
    actual_d(k) = norm(pos - [xc(k) yc(k)]);
end

n_len = zeros(1,3);
n_len(1) = len(1);
n_len(2) = len(1) + len(2);
n_len(3) = len(1) + len(2) + len(3);

all_len = n_len(3);
w = zeros(1,all_len);
w_sum = 0;
for i = 1:all_len



    w(i) = landmark_detection_model(sample_x(i), sample_y(i));
    w_sum = w_sum + w(i);

    
end
w = w./w_sum;

resample_x = zeros(1,all_len);
resample_y = zeros(1,all_len);
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
        next_w(i) = w(i); 
    end
    w = next_w;
    w = w./sum(w);
    sample_x = resample_x;
    sample_y = resample_y;
%     all_len = floor(all_len / 5);

end
plot(resample_x, resample_y, '.');
m = mean(resample_x);
n = mean(resample_y);
circleplot(m,n,20,pi)




function p = landmark_detection_model(s_x, s_y)
     p = 1;
    for c = 1:3
        s_d = norm([s_x s_y] - [xc(c) yc(c)]);
        p = p * normpdf(s_d - actual_d(c), 0, 60);
    end
    
    
end

end
function circleplot(xc, yc, r, theta)
t = 0 : .01 : 2*pi;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y,'r','LineWidth',2)
t2 = 0 : .01 : r;
x = t2 * cos(theta) + xc;
y = t2 * sin(theta) + yc;
plot(x, y,'r','LineWidth',2)
end
