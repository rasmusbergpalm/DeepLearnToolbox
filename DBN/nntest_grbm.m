function [er, bad] = nntest_grbm(nn, x, y)
    nn.testing = 1;
    nn = nnff_grbm(nn, x, y);
    nn.testing = 0;
    
    [~, i] = max(nn.a{end},[],2);
    [~, g] = max(y,[],2);
    bad = find(i ~= g);    
    er = numel(bad) / size(x, 1);
end
