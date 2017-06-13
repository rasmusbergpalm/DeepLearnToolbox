function sum_value = sptsum(spcell)
sum_value = 0;
n = numel(spcell);
for i = 1:n
    m = spcell{i};
    sum_value = sum_value + sum(m(:));
end
end