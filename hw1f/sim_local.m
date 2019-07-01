function sim_local()

%%
T=0.01; % Sampling Time
k=2; % Sampling counter
x(k-1)=-0.3; % initilize the state x
y(k-1)=0; % initilize the state y
tfinal=100; % final simulation time
t=0; % intilize the time
pulse_points = [];
point_num = 0;    

xmin=-3; % setting the figure limits
xmax=3;
ymin=-3;
ymax=3;

while t <= tfinal
    % check whather reach the goal
    goal_dis = sqrt((x(k-1) - 2)^2 + (y(k-1) - 0)^2); 
    if goal_dis <= 0.1
        break
    end


    v = wall1_feild(x(k-1),y(k-1)) + wall2_feild(x(k-1),y(k-1)) + wall3_feild(x(k-1),y(k-1));
    v = v + goal_feild(goal_dis, x(k-1),y(k-1));
    v = v + pulse_point_feild(pulse_points, x(k-1), y(k-1));
    
    % chech whether  collide the wall
    if (abs(x(k-1)) <= 0.01 && y(k-1) >= -0.5 && y(k-1) <= 0.5) || (x(k-1) <= 0 && x(k-1) >= -1 && (abs(y(k-1) + 0.5) <= 0.01 || abs(0.5 - y(k-1)) <= 0.01)) 
        v = -v;
        point_num = point_num + 1;
        pulse_points(point_num * 2 - 1) = x(k-1);
        pulse_points(point_num * 2 ) = y(k-1);
    elseif abs(v(1)) <= 0.01 && abs(v(2)) <= 0.01
        % let robot only affected by goal
        v = goal_feild(goal_dis, x(k-1),y(k-1));
        % add some force to the direction perpendicular to v
        tmpv = v;
        v(1) = tmpv(1)-0.2*tmpv(2);
        v(2) = tmpv(2)+0.2*tmpv(1);
        point_num = point_num + 1;
        pulse_points(point_num * 2 - 1) = x(k-1);
        pulse_points(point_num * 2 ) = y(k-1);
    end
    h = 1;
    x(k) = v(1)*T + x(k-1);
    y(k) = v(2)*T + y(k-1);


    plot(x,y,'-r') % Dawing the Path
    axis([xmin xmax ymin ymax]) % setting the figure limits
    axis square
    hold on
    quiver(x(k-1),y(k-1),h*v(1),h*v(2)); % draw the speed vector
    draw_background();
%    draw_pulse_point()
    drawnow
    hold off
    
    
    t = t + T;
    k = k + 1;
end

%% ======= draw the field
[xs, ys] = meshgrid(linspace(xmin,xmax,50), linspace(ymin,ymax,50));
s = size(xs);
[vx, vy] = meshgrid(zeros(s(2),1) , zeros(s(1),1));
for i = 1:s(2)
    for j = 1:s(1)
        v = wall1_feild(xs(j,i),ys(j,i)) + wall2_feild(xs(j,i),ys(j,i)) + wall3_feild(xs(j,i),ys(j,i));
        goal_dis = sqrt((xs(j,i) - 2)^2 + (ys(j,i) - 0)^2);
        v = v + goal_feild(goal_dis, xs(j,i),ys(j,i));
        v = v + pulse_point_feild(pulse_points, xs(j,i),ys(j,i));
        vx(j,i) = 10*v(1);
        vy(j,i) = 10*v(2);
    end
end
plot(x,y,'-r') % Dawing the Path
axis([xmin xmax ymin ymax]) % setting the figure limits
axis square
hold on

for i = 1:2:length(pulse_points)
    point_r = 0.05;
    point_pos = [pulse_points(i)-point_r pulse_points(i+1)-point_r 2*point_r 2*point_r];
    rectangle('Position',point_pos,'Curvature',[1,1],'FaceColor','y');
end

draw_background();
quiver(xs,ys,vx,vy,10); % draw the final feild
drawnow



%



end

function draw_background()


    
    goal_r = 0.1;
    goal_pos = [2-goal_r 0-goal_r 2*goal_r 2*goal_r];
    rectangle('Position',goal_pos,'Curvature',[1,1],'FaceColor','r');
    
    rectangle('Position',[0 -0.5 0.1 1], 'Facecolor', 'b'); % wall1
    rectangle('Position',[-1 -0.6 1 0.1], 'Facecolor', 'b'); % wall2
    rectangle('Position',[-1 0.5 1 0.1], 'Facecolor', 'b'); % wall2    
end

function v = wall1_feild(x, y)
if y >= -0.5 && y <= 0.5
    v(1) = 1/x;
else
    v(1) = 0;
end
v(2) = 0;
end

function v = wall2_feild(x, y)
v(1) = 0;
if x>=-1 && x <= 0
v(2) = 1/(y + 0.5);
else
v(2) = 0;
end
end

function v = wall3_feild(x, y)
v(1) = 0;
if x>=-1 && x <= 0
v(2) = 1/(y - 0.5);
else
v(2) = 0;
end
end

function v = goal_feild(goal_dis, x,y)

v(1) = 2 - x;
v(2) = -y;
if goal_dis < 0.5
    v(1) = 5* v(1);
    v(2) = 5* v(2);
end
end

function v = pulse_point_feild(points, x, y)
v(1) = 0;
v(2) = 0;
k = 0.2;
R = 1;
r = 0.1;
for i = 1:2:length(points)
    tmpX = points(i);
    tmpY = points(i+1);
    dis = sqrt((x - tmpX)^2 + (y - tmpY)^2);
    if dis < R && dis > r
        v_pulse = k * (1/dis - 1/R) / (dis - R)^2;
        tmp = 1;
    elseif dis < r

        v_pulse = 2;
    else 
        v_pulse = 0;
    end
    v(1) = v(1) + (x - tmpX) * v_pulse / dis;
    v(2) = v(2) + (y - tmpY) * v_pulse / dis;
end

end













