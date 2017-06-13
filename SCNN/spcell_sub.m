function x = spcell_sub(x, y)
%{
x,y,z type: array<sparse<double>(x,y)>(n)
%}
if iscell(y) && iscell(x)
    n = numel(x);
    for i = 1:n
        x{i} = x{i} - y{i};
    end
elseif isa(y,'double') && iscell(x)
    n = numel(x);
    for i = 1:n
        x{i} = x{i} - y;
    end
elseif isa(x,'double') && iscell(y)
    n = numel(y);
    for i = 1:n
        y{i} = y{i} - x;
    end
    x = y;
else
    x = x - y;
end
end