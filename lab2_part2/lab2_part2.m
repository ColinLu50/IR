function lab2_part2()

goalRadius = 0.5;
path = [0 0;
    2 0;
    0.2 0.5;
    1 2.5;
    4 2.5;
    5 0];;

lookaheadR = 0.2; % look ahead distance
v = 0.2;



robotGoal = path(end,:);

rosshutdown;
setenv('ROS_MASTER_URI', 'http://10.21.18.168:11311');
setenv('ROS_IP','10.21.18.168');
rosinit('http://10.21.18.168:11311','NodeHost','10.21.18.168');

linkStates = rossubscriber('/gazebo/link_states');
stateData = receive(linkStates);

posesub = rossubscriber('/tf');
posedata = receive(posesub);
robot_pos = posedata.Transforms.Transform.Translation;


% robot_ori = posedata.Transforms.Transform.Rotation;
velpub = rospublisher('/cmd_vel');
velmsg = rosmessage(velpub);
distanceToGoal = norm([robot_pos.X robot_pos.Y] - robotGoal);
orientation = stateData.Pose(2,1).Orientation.Z * pi;
robotCurrentPose = [robot_pos.X robot_pos.Y orientation]
while distanceToGoal > goalRadius
    
    [lookahead_x,lookahead_y] = getLookaheadPoint(robotCurrentPose(1:2));
    w = getW(robotCurrentPose);
    
    velmsg.Linear.X = v;
    velmsg.Angular.Z = w;
    send(velpub,velmsg);
    posedata = receive(posesub);
    robot_pos = posedata.Transforms.Transform.Translation;
    stateData = receive(linkStates);
    orientation = stateData.Pose(2,1).Orientation.Z * pi;
    robotCurrentPose = [robot_pos.X robot_pos.Y orientation]
    
    distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal);
end

velmsg.Linear.X = 0;
velmsg.Angular.Z = 0;
send(velpub,velmsg);




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
        
        if(abs(w) > 2.5)
            w = sign(w)*2.5;
        end
        
    end
end