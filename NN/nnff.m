function net = nnff(net, x, y)
    n = numel(net.size);
    m = size(x,1);
    net.a{1} = x;

    %% feedforward pass
    for i=2:n
%         net.a{i} = sigm(net.W{i-1}*net.a{i-1}+net.b{i-1});
        net.a{i} = sigm(repmat(net.b{i-1}',m,1) + net.a{i-1}*net.W{i-1}');
    end
    net.e = y-net.a{n};
    net.L = 1/2*sum(sum(net.e.^2))/m; 
end