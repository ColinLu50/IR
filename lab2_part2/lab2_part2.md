# lab2 part2

11610310  Lu Ning

## Simulation

**The simulation video is "demo.mp4".**

### Start

![start](/home/luning/workspace/IR/lab2_part2/start.png)

### run back

![path1](/home/luning/workspace/IR/lab2_part2/path1.png)

![path2](/home/luning/workspace/IR/lab2_part2/path2.png)

### Run out of the barrier

![path3](/home/luning/workspace/IR/lab2_part2/path3.png)

![path4](/home/luning/workspace/IR/lab2_part2/path4.png)

![path5](/home/luning/workspace/IR/lab2_part2/path5.png)

### Reach the target

![final](/home/luning/workspace/IR/lab2_part2/final.png)





## Code

I set some fixed points and let the robot move along the set path.

The navigation algorithm is look ahead algorithm, I explained it thoroughly in report of **lab2_part1**.

### Procedure:

- Subscribe to topic **"/tf"** to get the robot's position

  ```matlab
  posedata = receive(posesub);
  robot_pos = posedata.Transforms.Transform.Translation;
  ```

- Subscribe to topic **"/gazebo/link_states"** to get robot's orientation

  ```matlab
  stateData = receive(linkStates);
  orientation = stateData.Pose(2,1).Orientation.Z * pi;
  ```

- Use the look-ahead track algorithm to get the linear speed and angular speed.

  ```matlab
  % robotCurrentPose = [robot_pos.X robot_pos.Y orientation]
  [lookahead_x,lookahead_y] = getLookaheadPoint(robotCurrentPose(1:2));
  w = getW(robotCurrentPose) 
  ```

- Set the speed data and publish to **"/cmd_vel"**.

  ```matlab
  velmsg.Linear.X = v;
  velmsg.Angular.Z = w;
  send(velpub,velmsg);
  ```

- Repeat the process until the robot reaches the target point (the ball).

  



