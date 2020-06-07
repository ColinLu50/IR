clc,clear

% line [-0.5 3] to [-0.5 4] is a side of a rectangle
line = ones(2,100);
line(2,:) = linspace(3,4,100);
line(1,:) = -0.5 .* line(1,:); 
line = line';

% map have a line and two points [0.1 1.5] [-0.15 1]
map = [0.1 1.5;
       -0.15 1;
       line];


xt = [];
global z_MAX;
z_MAX = 5;

sample_time = 10000;
zt = linspace(0, z_MAX, sample_time);
q = zeros(1, sample_time);
for i = 1:sample_time
    q(i) = likelihood_field_model(zt(i),xt,map);

end
figure(1), clf;
plot(zt,q/sum(q(:)))







function [q]=likelihood_field_model(z_k,xt,m)

q=1;       
N=1;     
   % 

z_max=0.3;
z_hit=0.6;
z_rand=0.1;


x=0;
y=0;
theta=pi/2;
x_sens=0;
y_sens=0;
theta_sens=0;
 
x_dot=0;
y_dot=0;
 
x_zt=zeros(1,N);
y_zt=zeros(1,N);
 
for k=1:N
    
    if z_k(k)~=z_max
        x_zt(k) = x + x_sens * cos(theta) - ...
            y_sens * sin(theta) + z_k(k) * cos(theta + theta_sens);
        y_zt(k) = y + y_sens * cos(theta) + ...
            x_sens * sin(theta) + z_k(k) * sin(theta + theta_sens);

        min_dist = 1000000;
        
        m_size = size(m);
        for i = 1:m_size(1)
            dist = norm([x_zt(k) y_zt(k)] - m(i,1:2));
            if dist < min_dist
                min_dist = dist;
            end
                
        end
        
        q = q * (z_hit * normpdf(min_dist, 0, 0.3) + z_rand / z_max);
        
    end
    if z_k(k) >= 4.9 && z_k(k) <= 5
        q = q + z_max * 1;
    end
end
 
% % prob_distribution(z,x,m)
% function y=prob(zt,xt,m)
%     min_dist = 0;
%     y = normpdf(zt,xt,m);
% end
 
end
 