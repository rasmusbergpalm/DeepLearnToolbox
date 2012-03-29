function net = nnapplygrads(net)
    %  TODO add momentum

    alpha  = net.alpha;
    lambda = net.lambda;

    for i = 1 : (net.n - 1)
        net.W{i} = net.W{i} - alpha * (net.dW{i} + lambda * net.W{i});
        net.b{i} = net.b{i} - alpha * net.db{i};
    end
end
