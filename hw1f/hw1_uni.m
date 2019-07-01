function hw1_uni()
    xmin = -1;
    xmax = 1;
    ymin = -1;
    ymax = 1;
    dx = 0.5;
    dy = 0.5;
    
    
    
    [x, y] = meshgrid(xmin:dx:xmax, ymin:dy:ymax);
    s = size(x);
    [vx, vy] = meshgrid(zeros(s(2),1) , zeros(s(1),1));
    vx = vx + 0.2;
    quiver(x,y,vx,vy);
    
end