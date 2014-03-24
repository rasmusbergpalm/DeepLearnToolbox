function [predicted_label, er, bad] = cnntest(net, x, y)
    %  feedforward
    net = cnnff(net, x);
    [~, h] = max(net.o);
    [~, a] = max(y);
    bad = find(h ~= a);
	predicted_label = h-1;
    er = numel(bad) / size(y, 2);
end
