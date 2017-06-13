function X = spcell_sigm(X)
    % Sigmoid 激活函数
    n = numel(X);
    for i = 1:n
        X{i} = 1./(1+exp(-X{i}));
    end
end