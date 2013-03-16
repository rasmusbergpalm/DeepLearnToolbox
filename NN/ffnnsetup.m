function nn = ffnnsetup(architecture)
%FFNNSETUP creates a Feedforward Backpropagate Neural Network
% nn = ffnnsetup(architecture) returns an neural network structure with n=numel(architecture)
% layers, architecture being a n x 1 vector of layer sizes e.g. [784 100 10]

nn = nnsetup(); % always call constructor first 

    nn.size   = architecture;   % architecture being a n x 1 vector of layer sizes e.g. [784 100 10]
    nn.n      = numel(nn.size); % number of layers

    for i = 2 : nn.n   
        % weights and weight momentum
        % TODO please explain the magic numbers :)
        nn.W{i - 1} = (rand(nn.size(i), nn.size(i - 1)+1) - 0.5) * 2 * 4 * sqrt(6 / (nn.size(i) + nn.size(i - 1))); % random initialization of weights
        nn.vW{i - 1} = zeros(size(nn.W{i - 1})); % default W momentum is zero
        
        % average activations (for use with sparsity)
        nn.p{i}     = zeros(1, nn.size(i));   
    end
end
