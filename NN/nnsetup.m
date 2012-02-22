function net = nnsetup(net,x,y)
    %% init net
    net.size = [size(x,2) net.size size(y,2)];
    net.n = numel(net.size);
    net.alpha = 0.1;%learning rate 
    net.lambda = 0; %L2 regularization
    net.beta = 0;   %sparsity rate
    net.rho = 0.05; %sparsity target
    net.eta = 0;    %added noise
    
    
    for i=2:numel(net.size)
        net.b{i-1} = zeros(net.size(i), 1);
        net.W{i-1} = (rand(net.size(i), net.size(i-1))-0.5)*2*4*sqrt(6/(net.size(i)+net.size(i-1)));
        net.p{i} = zeros(1,net.size(i));
    end
end