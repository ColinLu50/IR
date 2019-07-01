# lab2 Part1

11610310  Lu Ning

## Differential Drive

- Advantages

  Degree of mobility is 2, is flexible.

  Simple sturcture

  Low cost

  Easy to control

  High workload

  

- Limits

  Can not move to any direction, need to move forward to change direction

  Need to have accurate information about the wheels to navigate properly

## Simulation

### Pure Pursuit Algorithm

- First, find the look ahead point, which is on the path.
- Then based on the look ahead point and current position to calculate the velocity and angular velocity.



#### Calculation process 

reference: [***Implementation of the Pure Pursuit Path Tracking Algorithm*** ](https://www.ri.cmu.edu/pub_files/pub3/coulter_r_craig_1992_1/coulter_r_craig_1992_1.pdf)

slightly different from the toolbox's controller

![ref1](/home/luning/workspace/IR/lab2_part1/ref1.png)



![ref2](/home/luning/workspace/IR/lab2_part1/ref2.png)



### Result

Character **'LN'**

##### running and print left/right wheel speed



![running](/home/luning/workspace/IR/lab2_part1/running.png)

##### look ahead distance = 0.3



![LN_3](/home/luning/workspace/IR/lab2_part1/LN_3.jpg)

##### look ahead distance = 0.1

![LN_1](/home/luning/workspace/IR/lab2_part1/LN_1.jpg)

##### look ahead distance = 0.5

![LN_5](/home/luning/workspace/IR/lab2_part1/LN_5.jpg)