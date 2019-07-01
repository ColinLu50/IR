function [mu, sigma, observedLandmarks] = correction_step(mu, sigma, z, observedLandmarks)
% Updates the belief, i. e., mu and sigma after observing landmarks, according to the sensor model
% The employed sensor model measures the range and bearing of a landmark
% mu: 2N+3 x 1 vector representing the state mean.
% The first 3 components of mu correspond to the current estimate of the robot pose [x; y; theta]
% The current pose estimate of the landmark with id = j is: [mu(2*j+2); mu(2*j+3)]
% sigma: 2N+3 x 2N+3 is the covariance matrix
% z: struct array containing the landmark observations.
% Each observation z(i) has an id z(i).id, a range z(i).range, and a bearing z(i).bearing
% The vector observedLandmarks indicates which landmarks have been observed
% at some point by the robot.
% observedLandmarks(j) is false if the landmark with id = j has never been observed before.

% Number of measurements in this time step
m = size(z, 2);

% Z: vectorized form of all measurements made in this time step: [range_1; bearing_1; range_2; bearing_2; ...; range_m; bearing_m]
% ExpectedZ: vectorized form of all expected measurements in the same form.
% They are initialized here and should be filled out in the for loop below
Z = zeros(m*2, 1);
expectedZ = zeros(m*2, 1);

% Iterate over the measurements and compute the H matrix
% (stacked Jacobian blocks of the measurement function)
% H will be 2m x 2N+3
H = [];

%current robot pose
x = mu(1);  
y = mu(2); 
theta = mu(3);  
for i = 1:m
	% Get the id of the landmark corresponding to the i-th observation
	landmarkId = z(i).id;
	range =  z(i).range;
	bearing = z(i).bearing;
	% If the landmark is obeserved for the first time:
	if(observedLandmarks(landmarkId)==false)
		% TODO: Initialize its pose in mu based on the measurement and the current robot pose:
		mu(2*landmarkId+2) = x + range*cos(bearing+theta);
		mu(2*landmarkId+3) = y + range*sin(bearing+theta);
		
		% Indicate in the observedLandmarks vector that this landmark has been observed
		observedLandmarks(landmarkId) = true;
    end

	% TODO: Add the landmark measurement to the Z vector
	Z(i*2-1: i*2) = [range;bearing];

	% TODO: Use the current estimate of the landmark pose
	% to compute the corresponding expected measurement in expectedZ:
	xi=mu(2*landmarkId+2);
	yi=mu(2*landmarkId+3);
	dx = (xi - x);
	dy = (yi-y);
	qq = dx^2 + dy^2;
	q = sqrt(qq);
	expectedZ(i*2-1,1) = q;
	expectedZ(i*2,1) = atan2(dy,dx) - theta;
	% TODO: Compute the Jacobian Hi of the measurement function h for this observation

	F = zeros(5, size(sigma,1));
	F(1:3,1:3) = eye(3);
	F(4,landmarkId*2+2) = 1;
	F(5,landmarkId*2+3) = 1;
	Hi = [-q*dx, -q*dy, 0, q*dx, q*dy;
		dy,-dx,-qq,-dy,dx]/qq;	
	Hi = Hi*F;
	% Augment H with the new Hi
	H = [H;Hi];	
    end

% TODO: Construct the sensor noise matrix Q
Q = eye(2*m)*0.01;

% TODO: Compute the Kalman gain
K = sigma*H'*inv(H*sigma*H'+Q);

% TODO: Compute the difference between the expected and recorded measurements.
% Remember to normalize the bearings after subtracting!
% (hint: use the normalize_all_bearings function available in tools)
diffZ = Z - expectedZ;
diffZ = normalize_all_bearings(diffZ);

% TODO: Finish the correction step by computing the new mu and sigma.
% Normalize theta in the robot pose.
mu = mu + K*(diffZ);
sigma = (eye(size(sigma,1))-K*H)*sigma;
end