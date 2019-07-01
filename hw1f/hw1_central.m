function [vx, vy] = hw1_central(x,y,xlen,ylen)
    r = 0.1;
    R = 0.8;
    k = -1;
    [vx, vy] = meshgrid(zeros(xlen,1) , zeros(ylen,1));
    for i = 1:xlen
        for j = 1:ylen
            if x(j,i)^2 + y(j,i)^2 > r ^ 2 && x(j,i)^2 + y(j,i)^2 < R ^ 2
                vx(j,i) = k*x(j,i);
                vy(j,i) = k*y(j,i);
            end
        end
    end
end