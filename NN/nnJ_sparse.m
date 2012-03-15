function J_sparse = nnJ_sparse(net, x, y)
    n      = net.n;
    lambda = net.lambda;

    J_sparse = nnJ(net, x, y);

    J_sparse = nnJ(net, x, y);

    for l = 1 : n
        J = J + (lambda / 2) * sum(sum(net.W{l} .^ 2));
    end

    J_sparse = J;
end
