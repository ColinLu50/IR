function hw5_1()

N = 1e6; % sample times
norm_x = zeros(1, N);
tri_x = zeros(1, N);
abs_x = zeros(1, N);


for i = 1:N
    norm_x(i) = sample_norm(1);
    tri_x(i) = sample_tri(1);
    abs_x(i) = sample_abs(1);
end

figure
h = histogram(norm_x,'FaceColor','g', 'EdgeAlpha',0);

figure

h = histogram(tri_x,'FaceColor','m', 'EdgeAlpha',0);
axis([-5 5 0 14000])
set(gca, 'XTick', -5:5);

figure
h = histogram(abs_x,'FaceColor','c', 'EdgeAlpha',0);



end

function x = sample_norm(b)
x = 0;
for i = 1:12
    x = x + (-b + 2 * b * rand());
end
x = x * 1/2;
end

function x = sample_tri(b)
x = (-b + 2 * b * rand()) + (-b + 2 * b * rand());
x = x * sqrt(6) / 2;
end

function x = sample_abs(b)

y_max = abs(b);
while(1)
    x = -b + 2 * b * rand();
    y = rand() * y_max;
    fx = abs(x);
    if y <= fx
        break
    end
    
end
end
