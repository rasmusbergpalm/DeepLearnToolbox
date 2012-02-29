function net = nnapplygrads(net)
    for i=1:(numel(net.size)-1)
        net.W{i} = net.W{i} - net.alpha * (net.dW{i} + net.lambda * net.W{i});
        net.b{i} = net.b{i} - net.alpha * net.db{i};
    end
end