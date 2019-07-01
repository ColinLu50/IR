function [vx, vy] = hw1_tang(x,y,xlen,ylen)
    r = 0.1;
    R = 0.8;
    k = -1;
    [vx, vy] = meshgrid(zeros(xlen,1) , zeros(ylen,1));
    for i = 1:xlen
        for j = 1:ylen
            rsquare = x(j,i)^2 + y(j,i)^2;
            if rsquare > r ^ 2 && rsquare < R ^ 2
                mod = rsquare^0.5;
                vx(j,i) = k*y(j,i);
                vy(j,i) = -k*x(j,i);
            end
        end
    end
end