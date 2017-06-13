function x = spcell_expand(x, expand_param)
    % x = spcell_ewop(x,@(u) expand(u,expand_param));
    n = numel(x);
    for i = 1:n
        x{i} = expand(x{i},expand_param);
    end
end