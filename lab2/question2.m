function question2()
%% =========== Set the paramters =======
T=0.01; % Sampling Time
k=2; % Sampling counter
tfinal=100; % final simulation time
t=0; % intilize the time

k1 = 3;
k2 = 8;
k3 = -2;
goal_theta = 0;
goal_x = 0;
goal_y = 0;
goal=[goal_x goal_y goal_theta];
if (k1 > 0 && k3 < 0 && (k2 + 3/5*k3 - 2/pi*k1) > 0)
    fprintf('do not change direction\n')
else
    return 
end
%=====================================
%% =========== initial the start position
curr = 0;
r = 4;
hold on
quiver(0, 0, cos(0), sin(0));
plot([0 0],[0.5 -0.5])
for i = 1:8
    x(i, k-1) = r*cos(pi/4 * i);
    y(i, k-1) = r*sin(pi/4 * i);
    theta(i,k-1) = pi/2;
    
    
end
%% =========== The main loop ==========
for i = 1:8
    k=2;
    % draw the initial pos
    quiver(x(i, k-1), y(i, k-1), cos(theta(i,k-1)), sin(theta(i,k-1)));
    
    plot([x(i, k-1)-0.5 x(i, k-1) + 0.5],[y(i, k-1) y(i, k-1)]);
    
    
    rho = sqrt(x(i,k-1)^2 + y(i,k-1)^2);
    alpha = -theta(i,k-1)+atan2(-y(i,k-1),-x(i,k-1));
    
    c=1;
    % alpha in range [-pi, pi]
    if alpha >= pi
        alpha = alpha - 2*pi;
    elseif alpha <= -pi
        alpha = alpha + 2*pi;
    end
    
    % change alpha to [-pi/2, pi/2] and let the robot run in reverse
    % direction
    if alpha > pi/2
        alpha = alpha - pi;
        c=-1;
    end
    if alpha < -pi/2
        alpha = alpha + pi;
        c = -1;
    end
    beta = -theta(i,k-1)-alpha;

       

    while(t<=tfinal)

        V = c*k1*rho;
        W = k2*alpha+k3*beta;
        
        theta(i,k) = theta(i,k-1)+W*T;
        vx = V*cos(theta(i,k));
        vy = V*sin(theta(i,k));
        if abs(vx) < 0.001 && abs(vy) < 0.001
            break
        end
        
        x(i,k)=x(i,k-1)+vx*T; % calculating x
        y(i,k)=y(i,k-1)+vy*T; % calculating y
        
        plot(x(i,1:(k-1)),y(i,1:(k-1)),'-r') % Dawing the Path
        hold on
        draw_back();
        drawnow

        
        
        drho =  -k1*rho*cos(alpha);
        dalpha = k1*sin(alpha)-k2*alpha-k3*beta;
        dbeta = -k1*sin(alpha);


        rho = rho + drho * T;
        alpha = alpha + dalpha*T;
        beta = beta + dbeta*T;


        k=k+1; % increase the sampling counter
        t=t+T; % increase the time
        if abs(y(i,k-1)) < 0.05 && abs(x(i,k-1)) < 0.05
            break
        end
    end
end
%% ========= draw the background
function draw_back()
xmin=-5; % setting the figure limits 
xmax=5;
ymin=-5;
ymax=5;
goal_pos = [-0.1 -0.1 0.2 0.2];
rectangle('Position',goal_pos,'Curvature',[1,1],'FaceColor','y');
axis([xmin xmax ymin ymax]) % setting the figure limits
axis square
grid on
end



end