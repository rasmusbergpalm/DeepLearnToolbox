function nn = nnsetup()
%% NNSETUP abstract setup method, set defaults here, 
% always call specific (cnnsetup,..) method, call thisone in your specific
% *setup method

% default
    nn.testing                          = 0;            % nntest sets this to one, NN does not learn, use for prediction/validation/test data
    nn.output                           = 'sigm';       % output unit 'sigm' (=logistic), 'softmax' and 'linear'
    nn.batchsize                        = 100;          % batchsize used. 1=online learning, size(data)=offline l., some value (100, 1000,...)=batch learning
    nn.numepochs                        = 5;            % how many sweeps through all dataset
    nn.plot                             = 1;            % display training progress
% learning (convergence speed)
    nn.activation_function              = 'tanh_opt';   %  Activation functions of hidden layers: 'sigm' (sigmoid) or 'tanh_opt' (optimal tanh).
    nn.learningRate                     = 2;            %  learning rate Note: typically needs to be lower when using 'sigm' activation function and non-normalized inputs.
    nn.momentum                         = 0.2;          %  Momentum, faster conv, better stability, rec. values 0~0.3
    nn.scaling_learningRate             = 0.99;         %  Scaling factor for the learning rate (each epoch), l.r. decline, (0.99^100=0.36)
% generalization (stability)  
    nn.weightPenaltyL2                  = 10^-5;        %  L2 regularization, weight decay, rec.val 10^-4~10^-5
    nn.nonSparsityPenalty               = 0;            %  Non sparsity penalty
    nn.sparsityTarget                   = 0.05;         %  Sparsity target
    nn.inputZeroMaskedFraction          = 0;            %  Used for Denoising AutoEncoders
    nn.dropout                          = 0.5;          %  Dropout level (http://www.cs.toronto.edu/~hinton/absps/dropout.pdf),0~-0.5, needs time to settle,percantage(0==off, 0.6==60% neur dropped out)
% other
    %nn.type    specific NN class used {'cnn','ffnn','dbn','sae','cae',...}
    %nn.W{i}    weights for each layer
    %nn.vW{i}   weights with momentum
    %nn.dW{i}   derivative of W
    %nn.a{i}    activation, input to layer
    %nn.o       output =result, nn.a{end}
    %nn.L       loss 
    %nn.rL      running loss (smooth over past values)
    %nn.p{i}    average activations (for sparsity)
end