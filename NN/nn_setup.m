%function net = nn_setup(net, x, y)
function net = nn_setup(layers)
    %%  init net
    net.size   = layers
    net.n      = numel(net.size);
    net.alpha  = 0.1;    %  learning rate 
    net.lambda = 0;      %  L2 regularization
    net.beta   = 0;      %  sparsity rate
    net.rho    = 0.05;   %  sparsity target
    net.eta    = 0;      %  added noise

    for i = 2 : net.n
        net.b{i - 1} = zeros(net.size(i), 1);   %  biases?
                                                %  weights?
        net.W{i - 1} = (rand(net.size(i), net.size(i - 1)) - 0.5) * 2 * 4 * sqrt(6 / (net.size(i) + net.size(i - 1)));
        net.p{i}     = zeros(1, net.size(i));   %  rhos?
    end
end
