function nn = nnsetup(size)
%NNSETUP creates a Feedforward Backpropagate Neural Network
% nn = nnsetup(size) returns an neural network structure with n=numel(size)
% layers, size being a n x 1 vector of layer sizes e.g. [784 100 10]

    nn.size   = size;
    nn.n      = numel(nn.size);
    nn.alpha  = 0.1;    %  learning rate 
    nn.lambda = 0;      %  L2 regularization
    nn.beta   = 0;      %  sparsity rate
    nn.rho    = 0.05;   %  sparsity target
    nn.eta    = 0;      %  hidden layer noise level.
    nn.inl    = 0;      %  input noise level. Used for Denoising AutoEncoders

    for i = 2 : nn.n
        nn.b{i - 1} = zeros(nn.size(i), 1);   %  biases
                                              %  weights
        nn.W{i - 1} = (rand(nn.size(i), nn.size(i - 1)) - 0.5) * 2 * 4 * sqrt(6 / (nn.size(i) + nn.size(i - 1)));
        nn.p{i}     = zeros(1, nn.size(i));   %  rhos
    end
end
