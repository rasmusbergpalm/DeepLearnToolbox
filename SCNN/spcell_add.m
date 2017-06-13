function x = spcell_add(x, y)
%{
x,y,z type: array<sparse<double>(x,y)>(n)
%}
if iscell(y) && iscell(x)
    n = numel(x);
    for i = 1:n
        x{i} = x{i} + y{i};
    end
elseif isa(y,'double') && iscell(x)
    x = spcell_ewop(x,@(u) u+y);
elseif isa(x,'double') && iscell(y)
    x = spcell_ewop(y,@(u) u+x);
else
    x = x + y;
end
end