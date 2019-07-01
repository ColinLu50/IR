# Intelligent Robot Homework2

11610310  Lu Ning

## Question1 

Discuss the advantages and limits of different wheel drives (for differential drive, Ackerman Drive, Synchronous Drive, XR4000 drive, and MecanumDrive, list their pros and cons in terms of cost, degree of mobility, degree of steerability, degree of maneuverability,  workload capacity, motion control complexity)

| Robot              | D<sub>m</sub> | D<sub>s</sub> | D<sub>M</sub> |
| :----------------- | :------------ | :------------- | :------------- |
| Differential Drive | 2             | 0             | 2             |
| Ackerman Drive     | 1             | 1             | 2             |
| Synchronous Drive  | 1             | 1             | 2             |
| XR4000 drive       | 3             | 0             | 3             |
| Mecanum Drive      | 3             | 0             | 3             |

### Differential Drive

- Pros
	- High mobility.
	- Low cost, structure is simple
	- Motion control is easy
	- High workload
- Cons
	- Cannot move to any direction, need to move forward to change the direction. It's important to have accurate information on wheel position. 

### Ackerman Drive

- Pros
	- High degree of steerable
	- Low cost, easy to build
	- Motion control is easy, it's easy to go straight with ackerman vehicle.
	- High workload 	
- Cons
	- Low mobility
###  Synchronous Drive

- Pros
  -  Can move to any direction
  -  Easy to build, only one motor
  -  Three wheels are in same mode, it's easy to go straight.
- Cons
  - Orientation of the chassis is not controllable



### XR4000 Drive

- Pros
	- High streerable, four motorized and steered castor wheels
	- High mobility
- Cons
	- Difficult to control the robot.
	
### Mecanum Drive

- Pros
	- Degree of mobility is 3, can move to any direction
- Cons
	- Difficult to control, four wheels need to fit complex constraints.
	- Workload is low because of  wheels' energy offset 

## Question 2

We can change the velocity of the two fixed wheels to control the motion of the robot. 

The red polygons are obstacles and the yellow ball is the goal.



![q2](/home/luning/workspace/matlab/hw2/q2.jpg)

## Question 3

Use the following equations.
![Screenshot from 2019-03-11 21-18-44](/home/luning/Pictures/Screenshot from 2019-03-11 21-18-44.png)

This formula assume the goal position is at  (0, 0)  and goal $\theta$ is 0.

My simulation :

![q3_2](/home/luning/workspace/matlab/hw2/q3_2.jpg)