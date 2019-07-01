function hw1_perpen()
    xmin = -1;
    xmax = 1;
    ymin = -1;
    ymax = 1;
    dx = 0.1;
    dy = 0.1;
    
    
    
    [x, y] = meshgrid(xmin:dx:xmax, ymin:dy:ymax);
    s = size(x);
    [vx, vy] = meshgrid(zeros(s(2),1) , zeros(s(1),1));
    vy = vy + 1;
    quiver(x,y,vx,vy);
    pos = [-1 -1.1 2 0.1];
    rectangle('Position', pos);
    
end