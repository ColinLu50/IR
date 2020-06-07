clc,clear

K = 10000;
z_tk = linspace(0,5,K);
q = beam_range_finder_model(z_tk,K);
figure(1), clf;
plot(z_tk,q/sum(q(:)))

function [q]=beam_range_finder_model(z_tk, K)


% [zhit  zshort  zmax  zrand  sigma_hit  zmax_range  lambda_short]
params = [0.40  0.20  0.25  0.15  0.1  5  .5];
% 
%  noise = 0.5;
%  z_tk_star = zt;
%  z_tk = z_tk_star + noise;
 

z_hit=params(1);
z_short=params(2);

z_max= params(3);
z_rand= params(4);
sigma_hit= params(5); 
lambda_short= params(7);
z_MAX = params(6);


z_tk_star = 3;
q=ones(1,K);
q(1)=1;
%Multiply the probability with weight
for k = 1:K
     z_tk_tmp = z_tk(k);
     q(k) = z_hit * p_hit(z_tk_tmp, z_tk_star, sigma_hit, z_MAX) + ...
            z_short * p_short(z_tk_tmp,z_tk_star,lambda_short) + ...
            z_max * p_max(z_tk_tmp,z_MAX) + ...
            z_rand * p_rand(z_tk_tmp,z_MAX);
            
end


 
% local measurement noise ！！normal distribution p_hit
function [p_hit]=p_hit(z_tk,z_tk_star,sigma_hit,z_MAX)
    
    if (0 <= z_tk && z_tk <= z_MAX) % eq (6.4)
        eta = normcdf([0 z_MAX], z_tk_star, sigma_hit); % eq (6.6)
        eta = eta(2)-eta(1);
        p_hit = eta*normpdf(z_tk, z_tk_star, sigma_hit);
    else
        p_hit = 0;
    end

end
 
% unexpected objects ！！ exponential distribution
function [p_short]=p_short(z_tk,z_tk_star,lambda_short)
%  TODO
    if (0 <= z_tk && z_tk <= z_tk_star) % eq (6.7)
        eta = 1/(1-exp(-lambda_short*z_tk_star)); % eq (6.9)
        mu = (1/lambda_short);
        p_short = eta*exppdf(z_tk,mu);
    else
        p_short = 0;
    end
end
 
% Failures
function [p_max]=p_max(z_tk,z_MAX)
% TODO
    if (z_MAX - 0.1 <= z_tk && z_tk <= z_MAX) % eq (6.10)
        p_max = 1;
    else
        p_max = 0;
    end

end
 
% Random measurements
function [p_rand] = p_rand(z_tk,z_MAX)
%  TODO
    if (0 <= z_tk && z_tk < z_MAX) % eq (6.11)
        p_rand = 1/z_MAX;
    else
        p_rand = 0;
    end

end
 
end
