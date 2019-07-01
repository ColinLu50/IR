function hw5_4()
    
% set up parameters for errors
a1 = 0.001;
a2 = 0.1;
a3 = 0.001;
a4 = 1;
a5 = 0.001;
a6 = 0.001;


% setting up initial v, w, r
v0 = 20;
w0 = 2;



% initial position
x0 = 1;
y0 = 0;
theta0 = pi/4;


% obstacle
ob_pos = [2 1.2 1 0.2];

% sample1
dt = 0.1;
next_point = zeros(3,500);
count = 1;
while count < 500
    vs = v0 + sample_norm(a1*v0^2 + a2*w0^2);
    ws = w0 + sample_norm(a3*v0^2 + a4*w0^2);
    rs =  sample_norm(a5*v0^2 + a6*w0^2);
    
    tmp_x = x0 - vs/ws*sin(theta0) + vs/ws*sin(theta0 + ws*dt);
    tmp_y = y0 + vs/ws*cos(theta0) - vs/ws*cos(theta0 + ws*dt);
    
    if~((tmp_x > 2 || tmp_x < 3) && (tmp_y > 1.2 && tmp_y < 1.4))
        next_point(1,count) = tmp_x;
        next_point(2,count) = tmp_y;
        next_point(3,count) = theta0 + ws*dt + rs*dt;
        	count = count + 1;
    end
    
    
    
    
    

end

    figure
    hold on
    plot(x0, y0, 'or');
    
    scatter(next_point(1,1:500),next_point(2,1:500),'.');
    rectangle('Position',ob_pos)


end

function x = sample_norm(b)
x = 0;
for i = 1:12
    x = x + (-b + 2 * b * rand());
end
x = x * 1/2;
end

