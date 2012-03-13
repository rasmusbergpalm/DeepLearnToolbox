function y = aeeval(net, x)
    n = net.n;
    m = size(x, 1);

    eta = net.eta;

    net.a{1} = x;

    if eta ~= 0
        net.a{2} = sigm(repmat(net.b{1}', m, 1) + net.a{1} * net.W{1}' + eta * randn(m, numel(net.b{1})));
    else
        net.a{2} = sigm(repmat(net.b{1}', m, 1) + net.a{1} * net.W{1}');
    end

    y = net.a{2};
end
