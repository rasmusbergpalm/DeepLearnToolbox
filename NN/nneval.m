function y = nneval(net, x, opts)
    n = net.n;
    m = size(x, 1);

    net.a{1} = x;

    for i = 2 : n
%        net.a{i} = sigm(repmat(net.b{i - 1}', m, 1) + net.a{i - 1} * net.W{i - 1}' + net.eta * randn(m, numel(net.b{i - 1})));
        net.a{i} = sigm(repmat(net.b{i - 1}', m, 1) + net.a{i - 1} * net.W{i - 1}');
    end

    y = net.a{n};
end
