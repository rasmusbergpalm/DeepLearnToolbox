function [er, bad] = cnntest(net, x, y)
%% CNNTEST test correctness of prediction of CNN
% x train data
% y validation labels

    %  feedforward
    net = cnnff(net, x);
    [~, h] = max(net.o);
    [~, a] = max(y);
    bad = find(h ~= a);

    er = numel(bad) / size(y, 2);
end
