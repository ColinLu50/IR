function lab2_1()
path = [1 5;
    1 1;
    3 1];

robotCurrentLocation = path(1,:);
robotGoal = path(end,:);
initialOrientation = 0;
robotCurrentPose = [robotCurrentLocation initialOrientation];

robotRadius = 0.4;
robot = ExampleHelperRobotSimulator('emptyMap',2)
robot.enableLaser(false);
robot.setRobotSize(robotRadius);
robot.showTrajectory(true);
robot.setRobotPose(robotCurrentPose);

plot(path(:,1), path(:,2),'k--d');
xlim([0 6])
ylim([0 6])

controller = robotics.PurePursuit
controller.Waypoints = path;
controller.MaxAngularVelocity = 2;
controller.LookaheadDistance = 0.5;
goalRadius = 0.1;
distanceToGoal = norm(robotCurrentLocation - robotGoal);

controlRate = robotics.Rate(10);
while(distanceToGoal > goalRadius)
    [v,omega] = controller(robot.getRobotPose);
    drive(robot,v,omega);
    
    robotCurrentPose = robot.getRobotPose;
    distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal);
    waitfor(controlRate);
end

%delete(robot);
end
