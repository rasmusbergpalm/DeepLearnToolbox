function [net y_hat L2_error] = nnff2(net, x, y)
    n = net.n;
    m = size(x, 1);

    %%  feedforward pass
    net.a{1} = x;
    for i = 2 : n
        net.a{i} = sigm(repmat(net.b{i - 1}', m, 1) + net.a{i - 1} * net.W{i - 1}');
%        size(net.a{i})
        net.p{i} = sum(net.a{i}, 1) / size(net.a{i}, 1);

        net.rho_hat{i} = mean(net.a{i}, 1);
    end

    y_hat = net.a{n};

    if size(y) ~= size(y_hat)
        size(y)
        size(y_hat)
    end

    net.e = y - y_hat;
    net.L = 0.5 * sum(sum(net.e .^ 2)) / m;

    L2_error = net.L;
end
