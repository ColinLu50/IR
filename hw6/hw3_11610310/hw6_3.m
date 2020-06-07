function hw6_3

landmarks = [0 0;
             2 0;
             2 2];
robot_position = [4 1];
actual_distance = zeros(1, 3);
noised_distance = zeros(1, 3);
for i = 1:3
    actual_distance(i) = norm(robot_position - landmarks(i,:));
%     noised_distance(i) =  actual_distance(i) + random('Normal',0,0.1);
end

f = @func;
x0 = [1 2];

sample_time = 1000;
x = zeros(sample_time,2);
for k = 1:sample_time
    for i = 1:3
%     actual_distance(i) = norm(robot_position - landmarks(i,:));
        noised_distance(i) =  actual_distance(i) + random('Normal',0,0.02);
    end
    x(k,:) = fsolve(f,x0);
%     x(k) = fsolve(f,x0);
end

figure
hold on

scatter(landmarks(:,1),landmarks(:,2),'r','filled');

scatter(x(:,1), x(:,2), 5, 'g' ,'filled');
scatter(robot_position(1), robot_position(2), 30,'+');






function F = func(x)

    F(1) = (x(1) - landmarks(1,1))^2 + (x(2) - landmarks(1,2))^2 - (noised_distance(1))^2;
    F(2) = (x(1) - landmarks(2,1))^2 + (x(2) - landmarks(2,2))^2 - (noised_distance(2))^2;
    F(3) = (x(1) - landmarks(2,1))^2 + (x(2) - landmarks(2,2))^2 - (noised_distance(3))^2;
%     for j = 1:2
%         tmp1 = (x(1) - landmarks(j,1))^2 + (x(2) - landmarks(j,2))^2;
%         tmp2 = (actual_distance(j) + random('Normal',0,1))^2;
%         F(j) = tmp1 - tmp2;
%     end

end
end

