function [mu, sigma] = prediction_step(mu, sigma, u)
% Updates the belief concerning the robot pose according to the motion model,
% mu: 2N+3 x 1 vector representing the state mean
% sigma: 2N+3 x 2N+3 covariance matrix
% u: odometry reading (r1, t, r2)
% Use u.r1, u.t, and u.r2 to access the rotation and translation values

% Compute the new mu based on the noise-free (odometry-based) motion model
% Remember to normalize theta after the update (hint: use the function normalize_angle available in tools)


% TODO: Compute the 3x3 Jacobian Gx of the motion model
theta = mu(3);
mu(1) = mu(1) + u.t*cos(theta + u.r1);
mu(2) = mu(2) + u.t*sin(theta + u.r1);
mu(3) = normalize_angle(theta + u.r1+u.r2);

% TODO: Compute the 3x3 Jacobian Gx of the motion model
Gx = eye(3); 
Gx(1,3) = -u.t*sin(theta+u.r1);
Gx(2,3) = u.t*cos(theta+u.r1);

% TODO: Construct the full Jacobian G
G = [Gx,zeros(3, size(sigma,2)-3);
     zeros(size(sigma,2)-3,3), eye(size(sigma)-size(Gx))];

% Motion noise
motionNoise = 0.1;
R3 = [motionNoise, 0, 0; 
     0, motionNoise, 0; 
     0, 0, motionNoise/10];
R = zeros(size(sigma,1));
R(1:3,1:3) = R3;

% TODO: Compute the predicted sigma after incorporating the motion

sigma = G*sigma*G' + R;
end

