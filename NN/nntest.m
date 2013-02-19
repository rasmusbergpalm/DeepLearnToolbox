function [er, bad] = nntest(nn, x, y)

    m = size(x, 1);
    if nn.normalize_input==1;
       x=zscore(x);
    end
    % Compact notation to include biases in the weight vector
    x=[ones(m,1) x];
    
    nn.testing = 1;
    nn = nnff(nn, x, y);
    nn.testing = 0;
    
    [~, i] = max(nn.a{end},[],2);
    [~, g] = max(y,[],2);
    bad = find(i ~= g);    
    er = numel(bad) / size(x, 1);
end
