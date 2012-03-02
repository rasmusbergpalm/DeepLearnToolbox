function [er, bad] = nntest(net, x, y)
    e = 0;
    bad = [];
    for i = 1 : size(x, 1)
        %  feedforward
        net = nnff(net, x(i, :), y(i, :));
        [~, g] = max(net.a{net.n});
        if g ~= find(y(i, :))
            e = e + 1;
            bad = [bad; i];
        end
    end
    er = e / size(x, 1);
end
