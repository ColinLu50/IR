function HW3_4()



rosinit

sim = ExampleHelperRobotSimulator('simpleMap');
setRobotPose(sim,[2 3 -pi/2]);
enableROSInterface(sim,true);
sim.LaserSensor.NumReadings = 50;

% robot.showTrajectory(true);

scanSub = rossubscriber('scan');
[velPub, velMsg] = rospublisher('/mobile_base/commands/velocity');

tftree = rostf;
pause(1);

path = [2 3;3.25 6.25; 2 11; 6 7; 11 11; 8 6; 10 5; 7 3; 11 1.5];
plot(path(:,1), path(:,2),'k--d');
robotCurrentLocation = path(1,:);
robotGoal = path(end,:);

controller = robotics.PurePursuit('Waypoints', path);
controller.DesiredLinearVelocity = 0.4;
controlRate = robotics.Rate(10);

goalRadius = 0.1;
distanceToGoal = norm(robotCurrentLocation - robotGoal);

map = robotics.OccupancyGrid(14,13,20);
figureHandle = figure('Name', 'Map');
axesHandle = axes('Parent', figureHandle);
mapHandle = show(map, 'Parent', axesHandle);
title(axesHandle, 'OccupancyGrid: Update 0');


% get the scan data
updateCounter = 1;
while( distanceToGoal > goalRadius )
    % Receive a new laser sensor reading.
    scanMsg = receive(scanSub);
    
    % Get robot pose at the time of sensor reading.
    pose = getTransform(tftree, 'map', 'robot_base', scanMsg.Header.Stamp, 'Timeout', 2);
    
    % Convert robot pose to 1x3 vector [x y yaw].
    position = [pose.Transform.Translation.X, pose.Transform.Translation.Y];
    orientation =  quat2eul([pose.Transform.Rotation.W, pose.Transform.Rotation.X, ...
        pose.Transform.Rotation.Y, pose.Transform.Rotation.Z], 'ZYX');
    robotPose = [position, orientation(1)];
    
    % Extract the laser scan.    insertRay(map, robotPose, modScan, sim.LaserSensor.MaxRange);

    scan = lidarScan(scanMsg);
    ranges = scan.Ranges;
    ranges(isnan(ranges)) = sim.LaserSensor.MaxRange;
    modScan = lidarScan(ranges, scan.Angles);
    
    % Insert the laser range observation in the map.
    insertRay(map, robotPose, modScan, sim.LaserSensor.MaxRange);
    
    % Compute the linear and angular velocity of the robot and publish it
    % to drive the robot.
    [v, w] = controller(robotPose);
    velMsg.Linear.X = v;
    velMsg.Angular.Z = w;
    send(velPub, velMsg);
    
    % Visualize the map after every 50th update.
    if ~mod(updateCounter,10)
        mapHandle.CData = occupancyMatrix(map);
        title(axesHandle, ['OccupancyGrid: Update ' num2str(updateCounter)]);
    end
    
    % Update the counter and distance to goal.
    updateCounter = updateCounter+1;
    distanceToGoal = norm(robotPose(1:2) - robotGoal);
    
    % Wait for control rate to ensure 10 Hz rate.
    waitfor(controlRate);
end
show(map, 'Parent', axesHandle);
title(axesHandle, 'OccupancyGrid: Final Map');

rosshutdown

end
