function perp_sim()
%% =========== Set the paramters =======
T=0.01; % Sampling Time
k=2; % Sampling counter
x(k-1)=0.05; % initilize the state x
y(k-1)=-0.5; % initilize the state y
tfinal=100; % final simulation time
t=0; % intilize the time 
h = 0.3; % modify the length for the velocity vector
while t <= tfinal
    t = t + T;
    % calculate the speed
    vx = 0;
    vy = 0.3;
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
    [vxs, vys] = meshgrid(zeros(s(2),1) , zeros(s(1),1));
    vys = vys + 0.3;
    quiver(xs,ys,vxs,vys);
    pos = [-1 -1.1 2 0.1];
    rectangle('Position', pos);
    r = 0.1;
    rectangle('Position',[x(k-1)-r y(k-1)-r 2*r 2*r],'Curvature',[1,1],'FaceColor','y');
 %   quiver(x(k-1),y(k-1),h*vx,h*vy);
    
    drawnow
    hold off
    k = k + 1;
end