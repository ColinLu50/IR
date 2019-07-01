function [mu, sigma] = prediction_step(mu, sigma, u)
    % Updates the belief, i. e., mu and sigma, according to the motion model
    %
    % u: odometry reading (r1, t, r2)
    % mu: 3 x 1 vector representing the mean (x, y, theta) of the normal distribution
    % sigma: 3 x 3 covariance matrix of the normal distribution

    % Compute the noise-free motion. This corresponds to the function g, evaluated
    % at the state mu.
    theta = mu(3);
    mu(1) = mu(1) + u.t*cos(theta + u.r1);
    mu(2) = mu(2) + u.t*sin(theta + u.r1);
    mu(3) = normangle(theta + u.r1+u.r2,-pi);

    % Compute the Jacobian of g with respect to the state
    G = eye(3); 
    G(1,3) = -u.t*sin(theta+u.r1);
    G(2,3) = u.t*cos(theta+u.r1);
    % Motion noise
    Q = [0.2, 0, 0;
        0, 0.2, 0;
        0, 0, 0.02];

    %sigma = % Todo: Implement
    sigma = G*sigma*G' + Q;
end
