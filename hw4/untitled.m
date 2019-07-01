mat = [0.9 0 0 0.1;
       0 0.8 0.1 0.1;
       0 0.1 0.8 0.1;
       0.1 0.1 0.1 0.7];
st0 = [0.5 0.5 0 0]';
change = 1;


while change > 0.00001

    st1 = mat * st0;
    tmp = abs(st1 - st0);
    change = max(tmp)
    st0 = st1;
end

a = st1