function att_sim()
%% =========== Set the paramters =======
T=0.01; % Sampling Time
k=2; % Sampling counter
x(k-1)=0.2; % initilize the state x
y(k-1)=-0.7; % initilize the state y
tfinal=100; % final simulation time
t=0; % intilize the time
h = 0.3; % modify the length for the velocity vector
while t <= tfinal
    t = t + T;
    % calculate the speed
    kv = -1;
    r = 0.1;
    R = 1;
    vx = 0;
    vy = 0;
    
    if x(k-1)^2 + y(k-1)^2 > r ^ 2 && x(k-1)^2 + y(k-1)^2 < R ^ 2
        vx = kv*x(k-1);
        vy = kv*y(k-1);
    end
    % get next time position
    x(k) = vx*T + x(k-1);
    y(k) = vy*T+ y(k-1);
    
    %     theta(k) = atan(vy/vx);
    %     draw_robot();
    xmin=-1.2; % setting the figure limits
    xmax=1.2;
    ymin=-1.2;
    ymax=1.2;
    dx = 0.1;
    dy = 0.1;
    plot(x,y,'-r') % Dawing the Path
    
    axis([xmin xmax ymin ymax]) % setting the figure limits
    axis square
    
    hold on
    %draw feild
    [xs, ys] = meshgrid(-1:dx:1, -1:dy:ymax);
    s = size(xs);
    [vxs, vys] = att(xs,ys,s(2),s(1));
    quiver(xs,ys,vxs,vys);
    % draw the robot
    r = 0.1;
    rectangle('Position',[x(k-1)-r y(k-1)-r 2*r 2*r],'Curvature',[1,1],'FaceColor','y');
    %   quiver(x(k-1),y(k-1),h*vx,h*vy);
    
    drawnow
    hold off
    k = k + 1;
end

%%
    function [vx, vy] = att(x,y,xlen,ylen)
        [vx, vy] = meshgrid(zeros(xlen,1) , zeros(ylen,1));
        for i = 1:xlen
            for j = 1:ylen
                if x(j,i)^2 + y(j,i)^2 > r ^ 2 && x(j,i)^2 + y(j,i)^2 < R ^ 2
                    vx(j,i) = kv*x(j,i);
                    vy(j,i) = kv*y(j,i);
                end
            end
        end
    end
end