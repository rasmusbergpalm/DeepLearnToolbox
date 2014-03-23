function [predicted_label, er, bad] = cnntest(net, x, y)
    %  feedforward
    net = cnnff(net, x);
    [~, predicted_label] = max(net.o);
    [~, a] = max(y);
    bad = find(predicted_label ~= a);

    er = numel(bad) / size(y, 2);
end
