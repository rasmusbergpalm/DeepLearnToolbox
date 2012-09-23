function net = nnbp(net)
    n = net.n;
    %%  backprop
    d{n} = - net.e .* (net.a{n} .* (1 - net.a{n}));
    for i = (n - 1) : -1 : 2
        pi = repmat(net.p{i}, size(net.a{i}, 1), 1);
        d{i} = (d{i + 1} * net.W{i} + net.beta * (-net.rho ./ pi + (1 - net.rho) ./ (1 - pi))) .* (net.a{i} .* (1 - net.a{i}));
    end

    for i = 1 : (n - 1)
        net.dW{i} = (d{i + 1}' * net.a{i}) / size(d{i + 1}, 1);
        net.db{i} = sum(d{i + 1}, 1)' / size(d{i + 1}, 1);
    end
end
