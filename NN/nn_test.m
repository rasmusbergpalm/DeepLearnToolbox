function [er, bad] = nn_test(net, x, y)
    e = 0;
    bad = [];
    for i = 1 : size(x, 1)
        %  feedforward
        net = nn_ff(net, x(i, :), y(i, :));
        [~, g] = max(net.a{net.n});
        if g ~= find(y(i, :))
            e = e + 1;
            bad = [bad; i];
        end
    end
    er = e / size(x, 1);
end
