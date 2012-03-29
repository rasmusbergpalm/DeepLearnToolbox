function net = nnff(net, x, y)
    n = net.n;
    m = size(x, 1);

    eta = net.eta;

    net.a{1} = x;
    if eta ~= 0
        %%  feedforward pass
        for i = 2 : n
            net.a{i} = sigm(repmat(net.b{i - 1}', m, 1) + net.a{i - 1} * net.W{i - 1}' + eta * randn(m, numel(net.b{i - 1})));
            net.p{i} = 0.99 * net.p{i} + 0.01 * sum(net.a{i}, 1) / size(net.a{i}, 1);

            net.rho_hat{i} = sum(net.a{i}, 1) / size(net.a{i}, 1);
        end
    else
        %%  feedforward pass
        for i = 2 : n
            net.a{i} = sigm(repmat(net.b{i - 1}', m, 1) + net.a{i - 1} * net.W{i - 1}');
            net.p{i} = 0.99 * net.p{i} + 0.01 * sum(net.a{i}, 1) / size(net.a{i}, 1);

            net.rho_hat{i} = sum(net.a{i}, 1) / size(net.a{i}, 1);
        end
    end

    net.e = y - net.a{n};
    net.L = 1/2 * sum(sum(net.e .^ 2)) / m;
%    net.L = 0.5 * sum(sum(net.e .^ 2)) / m;
end
