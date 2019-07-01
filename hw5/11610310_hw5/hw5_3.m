function hw5_3()

% set up parameters for errors
a1 = 0.001;
a2 = 0.001;
a3 = 0.001;
a4 = 1;
a5 = 0.001;
a6 = 0.001;


% setting up initial v, w, r
v0 = 2;
w0 = 2;
r = 2;


% initial position
x0 = 1;
y0 = 0;
theta0 = pi/3;

% sample1
dt = 0.1;
next_point = zeros(3,500);
for i = 1:500
    vs = v0 + sample_norm(a1*v0^2 + a2*w0^2);
    ws = w0 + sample_norm(a3*v0^2 + a4*w0^2);
    rs =  sample_norm(a5*v0^2 + a6*w0^2);
    
    next_point(1,i) = x0 - vs/ws*sin(theta0) + vs/ws*sin(theta0 + ws*dt);
    next_point(2,i) = y0 + vs/ws*cos(theta0) - vs/ws*cos(theta0 + ws*dt);
    next_point(3,i) = theta0 + ws*dt + rs*dt;
    
end

    figure
    plot(x0, y0, 'or');
    hold on
    scatter(next_point(1,1:500),next_point(2,1:500),'.');


% sample 2

a1 = 0.01;
a2 = 0.01;
a3 = 0.01;
a4 = 0.1;
a5 = 1;
a6 = 1;

for i = 1:500
    vs = v0 + sample_norm(a1*v0^2 + a2*w0^2);
    ws = w0 + sample_norm(a3*v0^2 + a4*w0^2);
    rs =  sample_norm(a5*v0^2 + a6*w0^2);
    
    next_point(1,i) = x0 - vs/ws*sin(theta0) + vs/ws*sin(theta0 + ws*dt);
    next_point(2,i) = y0 + vs/ws*cos(theta0) - vs/ws*cos(theta0 + ws*dt);
    next_point(3,i) = theta0 + ws*dt + rs*dt;
    
end


figure
plot(x0, y0, 'or');
hold on
scatter(next_point(1,1:500),next_point(2,1:500),'.');


% sample 3

a1 = 0.01;
a2 = 0.001;
a3 = 0.001;
a4 = 0.8;
a5 = 0.001;
a6 = 0.001;

theta0 = pi/2.5;
for i = 1:500
    vs = v0 + sample_norm(a1*v0^2 + a2*w0^2);
    ws = w0 + sample_norm(a3*v0^2 + a4*w0^2);
    rs =  sample_norm(a5*v0^2 + a6*w0^2);
    
    next_point(1,i) = x0 - vs/ws*sin(theta0) + vs/ws*sin(theta0 + ws*dt);
    next_point(2,i) = y0 + vs/ws*cos(theta0) - vs/ws*cos(theta0 + ws*dt);
    next_point(3,i) = theta0 + ws*dt + rs*dt;
    
end
figure
plot(x0, y0, 'or');
hold on
scatter(next_point(1,1:500),next_point(2,1:500),'.');


end

function x = sample_norm(b)
x = 0;
for i = 1:12
    x = x + (-b + 2 * b * rand());
end
x = x * 1/2;
end