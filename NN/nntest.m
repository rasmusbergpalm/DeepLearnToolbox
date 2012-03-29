function [er, bad] = nntest(net, x, y)
    e = 0;
    bad = [];
    for i = 1 : size(x, 1)
        %  feedforward
%        net = nnff(net, x(i, :), y(i, :));
        net = nnff2(net, x(i, :), y(i, :));

        weights = sort(net.a{2}, 2, 'descend');
        fprintf('%d.  ', find(y(i, :)) - 1)
        fprintf('%.3f ', weights(1 : 4))
        fprintf('\n')

        [~, g] = max(net.a{net.n});
        if g ~= find(y(i, :))
            e = e + 1;
            bad = [bad; i];
        end
    end
    er = e / size(x, 1);
end
