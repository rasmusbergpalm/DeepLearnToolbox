function [er, bad] = nntest(nn, x, y)
%% NNTEST test if prediction on train data x
% agrees with labels y

    labels = nnpredict(nn, x);
    [~, expected] = max(y,[],2);
    bad = find(labels ~= expected);    
    er = numel(bad) / size(x, 1);
end
