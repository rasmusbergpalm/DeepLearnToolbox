function x = spcell_ewop(x, operation)
%{
    函数功能：使用操作符对每一个元素进行操作
%}
    n = numel(x);
    for i = 1:n
        x{i} = operation(x{i});
    end
end