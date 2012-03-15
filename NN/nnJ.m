function J = nnJ(net, x, y)
    n      = net.n;
    lambda = net.lambda;

    J = 1 / (2 * m) * sum((nneval(net, x) - y) .^ 2);

    for l = 1 : n
        J = J + lambda / 2 * sum(sum(net.W{l} .^ 2));
    end
end
