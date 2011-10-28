function net = nnsetup(net,x,y)
    %% init net
    net.size = [size(x,2) net.size size(y,2)];
    net.n = numel(net.size);
    net.alpha = 0.1;
    
    for i=2:numel(net.size)
        net.b{i-1} = zeros(net.size(i), 1);
        net.W{i-1} = randn(net.size(i), net.size(i-1))*0.01;
    end
end