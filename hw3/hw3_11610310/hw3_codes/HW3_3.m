function HW3_3()
%%  consider the synchronization, the forth unknown variable is c*t(t is synchronization error)
s_pos= [15000 16000 4200; 40000 0 6000; 17000 -8000 52000; -24000 11000 -12000;12000 2000 21000 ]
u_T = 0;
scatter3(s_pos(:,1),s_pos(:,2),s_pos(:,3),'*');
hold on
u_pos = [10000 -25000 5000]
scatter3(u_pos(1), u_pos(2), u_pos(3),'o');
for j = 1:length(s_pos)
    plot3([s_pos(j,1) ;u_pos(1)], [s_pos(j,2) ;u_pos(2)], [s_pos(j,3) ;u_pos(3)])
end
Prange = CalculatePseudoRange(s_pos, u_pos)

fun1 = @CalculateUserPositionConsiderSync;
x0 = [0 0 0 0]
cal_u_pos = fsolve(fun1,x0);
scatter3(cal_u_pos(1), cal_u_pos(2), cal_u_pos(3),'filled')
for j = 1:length(s_pos)
    plot3([s_pos(j,1) ;cal_u_pos(1)], [s_pos(j,2) ;cal_u_pos(2)], [s_pos(j,3) ;cal_u_pos(3)])
end
view(45,30);
hold off

%% don't consider synchronization problem. just calculate x, y, z
figure 

scatter3(s_pos(:,1),s_pos(:,2),s_pos(:,3),'*');
hold on
scatter3(u_pos(1), u_pos(2), u_pos(3),'o');
for j = 1:length(s_pos)
    plot3([s_pos(j,1) ;u_pos(1)], [s_pos(j,2) ;u_pos(2)], [s_pos(j,3) ;u_pos(3)])
end

fun2 = @CalculateUserPosition;
x0 = [0 0 0]
cal_u_pos = fsolve(fun2,x0);
scatter3(cal_u_pos(1), cal_u_pos(2), cal_u_pos(3),'filled')
for j = 1:length(s_pos)
    plot3([s_pos(j,1) ;cal_u_pos(1)], [s_pos(j,2) ;cal_u_pos(2)], [s_pos(j,3) ;cal_u_pos(3)])
end
view(45,30);
hold off
    %% calculate teh pseudo range
    function Prange_result=CalculatePseudoRange(SatellitePosition, UserPosition)
        sync_err = 0.01;
        for i = 1:length(SatellitePosition)
            tmp = SatellitePosition(i,:) - UserPosition;
            Prange_result(i) = sqrt(tmp * tmp') - sync_err * 300000;
            
        end
       
    end
    %% calculate the user position when not sychronized
    function F = CalculateUserPositionConsiderSync(x)
        for i = 1:length(s_pos)
            tmp = s_pos(i,:) - x(1:3);
            F(i) = Prange(i) + x(4) - sqrt(tmp * tmp');
        end
    end

   %% calculate the user position when 
    function F = CalculateUserPosition(x)
        for i = 1:length(s_pos)
            tmp = s_pos(i,:) - x(1:3);
            F(i) = Prange(i) - sqrt(tmp * tmp');
        end
    end

end