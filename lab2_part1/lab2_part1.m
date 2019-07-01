function lab2_part1()


path = [2 0;
    0.5 1;
    1 2.5;
     6 2.5;
     7 0];

lookaheadR = 0.2; % look ahead distance
v = 0.2;
Max_w = 2;
robotCurrentLocation = path(1,:);
robotGoal = path(end,:);
initialOrientation = pi/2;
robotCurrentPose = [robotCurrentLocation initialOrientation];
% get the lookahead point


    
robotRadius = 0.4;
robot = ExampleHelperRobotSimulator('emptyMap',2)
robot.enableLaser(false);
robot.setRobotSize(robotRadius);
robot.showTrajectory(true);
robot.setRobotPose(robotCurrentPose);



plot(path(:,1), path(:,2),'k--d');
xlim([0 10]);
ylim([0 10]);





goalRadius = 0.1;
distanceToGoal = norm(robotCurrentLocation - robotGoal);

controlRate = robotics.Rate(10);
while(distanceToGoal > goalRadius)
    [lookahead_x,lookahead_y] = getLookaheadPoint(robotCurrentPose(1:2));
    w = getW(robotCurrentPose)
    drive(robot,v,w);
    
    robotCurrentPose = robot.getRobotPose;
    distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal);
    waitfor(controlRate);
end

%delete(robot);

function [lookaheadX, lookaheadY] = getLookaheadPoint(curr_pos)
    tmpx = -100;
    tmpy = -100;
    for i = 1:(length(path)-1)
        start_pos = path(i,:);
        end_pos = path(i+1,:);
        
        path_vector = end_pos - start_pos;
        angle = atan2(path_vector(2), path_vector(1));
        start_to_robot_vector = curr_pos - start_pos;
        % calculate the projection
        projection = path_vector * start_to_robot_vector' / norm(path_vector);
        
        %judge if the lookahead point is on this set of path
        dsqur = -start_to_robot_vector * start_to_robot_vector' + lookaheadR * lookaheadR + projection * projection;
        if dsqur > 0
            project_dis = projection + sqrt(dsqur);
            if(project_dis > 0 && project_dis < norm(path_vector))
                tmpx = start_pos(1) + project_dis * cos(angle);
                tmpy = start_pos(2) + project_dis * sin(angle);
            end
        end
    end

    % check if the robot is near the goal. If so, the lookahead point is
    % the goal
    if(norm(robotGoal - curr_pos)<=lookaheadR)
        tmpx = robotGoal(1);
        tmpy = robotGoal(2);
    end

    lookaheadX = tmpx;
    lookaheadY = tmpy;
end

function w = getW(curr_pose)
    
    % just consider w, similar to the toolbox's method
    
%     robot_to_lookahead = [lookahead_x lookahead_y] - curr_pose(1:2);
%     theta = curr_pose(3);
%     
%     w = acos(dot(robot_to_lookahead, [cos(theta) sin(theta)])/norm(robot_to_lookahead));
%     
%     if abs(w)>Max_w
%         w = Max_w
%     end
%     robot_x_vector = [cos(theta - pi/2), sin(theta - pi/2)];
%     projection_dis = -robot_to_lookahead * robot_x_vector';
%     w = sign(projection_dis) * abs(w)
    
    
    % another method
    % reference : https://www.ri.cmu.edu/pub_files/pub3/coulter_r_craig_1992_1/coulter_r_craig_1992_1.pdf
    theta = curr_pose(3);
    robot_x_vector = [cos(theta - pi/2), sin(theta - pi/2)];
    projection_dis = -[lookahead_x - curr_pose(1) lookahead_y - curr_pose(2)] * robot_x_vector';
    
    % calculate the moving radius r = l^2/(2x), in the robot coordinate
    % r has a sign in order to calculate w
    r = lookaheadR ^ 2 / (2*projection_dis);
    if abs(r) > 100000
        w = 0;
    else
        w = v/r;
    end
    if(abs(w) > 2)
        w = sign(w)*2;
    end
    r = abs(r);
    if w < 0
        vl = (r + robotRadius / 2) * abs(w);
        vr = (r - robotRadius / 2) * abs(w);
    elseif w == 0
        vl = v;
        vr = v;
    else
        vl = (r - robotRadius / 2) * abs(w);
        vr = (r + robotRadius / 2) * abs(w);
    end
    fprintf("left wheel speed: %f right wheel speed: %f\n", vl, vr)
end
end


