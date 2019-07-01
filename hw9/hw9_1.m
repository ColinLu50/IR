function hw9_1
clc;clear;
close all;
robot_x=10;
robot_y=10;
landmark_x=[5 ,5, 15, 15];
landmark_y=[5, 15, 5, 15];


axis([0 20 0 20]);
hold on;
for i=1:4
    curr_r = 0.5;
    rectangle('position', [landmark_x(i) - curr_r, landmark_y(i) - curr_r, curr_r, curr_r], 'curvature', [1, 1]);
end
dis= zeros(1, 4);
l = 1;
rectangle('position',[robot_x - l, robot_y - l, l, l]);

% calculate the actual distance between robot and landmarks
for i=1:4
    dis(i)=((landmark_x(i)-robot_x)^2+(landmark_y(i)-robot_y)^2)^(1/2);
end

% simulate the random landmarks distance
obs_dist = zeros(1, 4);
for i=1:4
    obs_dist(i)=dis(i)+normrnd(0,1);
end
k = zeros(1, 4);
k(1)=abs(obs_dist(1)-obs_dist(4));
k(2)=abs(obs_dist(4)-obs_dist(3));
k(3)=abs(obs_dist(3)-obs_dist(2));
k(4)=abs(obs_dist(2)-obs_dist(1));
init_min=-1;
for i=1:4
    if init_min == -1 || init_min<k(i)
        init_min=k(i);
    end
end
k(1)=abs(obs_dist(1)+obs_dist(4));
k(2)=abs(obs_dist(4)+obs_dist(3));
k(3)=abs(obs_dist(3)+obs_dist(2));
k(4)=abs(obs_dist(2)+obs_dist(1));
init_max=-1;
for i=1:4
    if init_max<k(i)
        init_max=k(i);
    end
end
init_solve=(init_min+init_max)/2;
func = @f1;
a=fsolve(func,init_solve);

z4 = getHight(Heron(a, obs_dist(1), obs_dist(4)), a);
z2 = getHight(Heron(a, obs_dist(3), obs_dist(4)), a);
z3 = getHight(Heron(a, obs_dist(3), obs_dist(2)), a);
z1 = getHight(Heron(a, obs_dist(1), obs_dist(2)), a);

plot(robot_x+z2,robot_y+z4,'ro');
plot(robot_x+z2,robot_y-z3,'ro');
plot(robot_x-z1,robot_y-z3,'ro');
plot(robot_x-z1,robot_y+z4,'ro');


function y = f1(x)
    y(1) = Heron(x(1), obs_dist(1), obs_dist(2)) + Heron(x(1), obs_dist(3), obs_dist(2)) + Heron(x(1), obs_dist(3), obs_dist(4)) + Heron(x(1), obs_dist(1), obs_dist(4)) - x(1)^2;
end
end

function S = Heron(a, b, c)
    s = (a + b + c) / 2;
    S = sqrt(s * (s - a) * (s - b) * (s - c));
end

function h = getHight(S, l)
    h = S * 2 / l;
end