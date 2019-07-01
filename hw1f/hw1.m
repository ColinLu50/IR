function hw1 ()

    xmin = -1;
    xmax = 1;
    ymin = -1;
    ymax = 1;
    dx = 0.1;
    dy = 0.1;

    
    %% draw the attractive feild
    [x, y] = meshgrid(xmin:dx:xmax, ymin:dy:ymax);
    s = size(x);
    [vx, vy] = att(x,y,s(2),s(1));
    quiver(x,y,vx,vy);
    %% draw the repulse feild
    figure;
    quiver(x,y,-vx,-vy);
    %% draw the tangential feild
    figure;
    [vx, vy] = tang(x,y,s(2),s(1));
    quiver(x,y,vx,vy);
    
    %% draw the uniform feild
    figure;
    [vx, vy] = meshgrid(zeros(s(2),1) , zeros(s(1),1));
    vx = vx + 0.2;
    quiver(x,y,vx,vy);

    %% draw the perpendicular feild
    figure;
    [vx, vy] = meshgrid(zeros(s(2),1) , zeros(s(1),1));
    vy = vy + 1;
    quiver(x,y,vx,vy);
    pos = [-1 -1.1 2 0.1];
    rectangle('Position', pos);
end

function [vx, vy] = tang(x,y,xlen,ylen)
    r = 0.1;
    R = 0.8;
    k = -1;
    [vx, vy] = meshgrid(zeros(xlen,1) , zeros(ylen,1));
    for i = 1:xlen
        for j = 1:ylen
            rsquare = x(j,i)^2 + y(j,i)^2;
            if rsquare > r ^ 2 && rsquare < R ^ 2

                vx(j,i) = k*y(j,i);
                vy(j,i) = -k*x(j,i);
            end
        end
    end
end

function [vx, vy] = att(x,y,xlen,ylen)
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
