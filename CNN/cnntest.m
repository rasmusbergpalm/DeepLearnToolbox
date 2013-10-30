function [er, bad] = cnntest(net, x, y)
    %  feedforward
    net = cnnff(net, x);
    [~, p_ind] = max(net.o, [], 2);
    [~, y_ind] = max(y, [], 2);
    bad = find(p_ind ~= y_ind);

    er = length(bad) / size(x, 3);
end
