function x = spcell_div(x, y)
%{
    函数功能：做spcell的（点）除法操作
%}
    if iscell(y) && iscell(x)
        n = numel(x);
        for i = 1:n
            x{i} = x{i} ./ y{i};
        end
    elseif isa(y,'double') && iscell(x)
        % x = spcell_ewop(x,@(u) u./y);
        n = numel(x);
        for i = 1:n
            x{i} = x{i}./y;
        end
    elseif isa(x,'double') && iscell(y)
        n = numel(y);
        for i = 1:n
            y{i} = x./y{i};
        end
        x = y;
    else
        x = x./y;
    end
end