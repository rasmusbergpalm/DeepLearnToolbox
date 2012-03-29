function nn = nninit(layers)

    nn.size   = layers;
    nn.n      = length(layers);
    nn.alpha  = 0.1;    %  learning rate
    nn.lambda = 0;      %  L2 regularization
    nn.beta   = 0;      %  sparsity rate
    nn.rho    = 0.05;   %  sparsity target
    nn.eta    = 0;      %  hidden layer noise level
    nn.inl    = 0;      %  input noise level. Used for Denoising AutoEncoders

    for i = 2 : nn.n
        nn.b{i - 1}   = zeros(nn.size(i), 1);
        nn.W{i - 1}   = (rand(nn.size(i), nn.size(i - 1)) - 0.5) * 2 * 4 * sqrt(6 / (nn.size(i) + nn.size(i - 1)));
        nn.p{i}       = zeros(1, nn.size(i));   %  rho-hats?
        nn.rho_hat{i} = zeros(1, nn.size(i));
        nn.db{i - 1}  = zeros(size(nn.b{i - 1}));
        nn.dW{i - 1}  = zeros(size(nn.W{i - 1}));
%
%        size(nn.b{i - 1})
%        size(nn.db{i - 1})
    end
end
