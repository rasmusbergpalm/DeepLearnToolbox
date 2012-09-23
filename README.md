DeepLearnToolbox
================

A Matlab toolbox for Deep Learning.

Deep Learning is a new subfield of machine learning that focuses on learning deep hierarchical models of data.
It is inspired by the human brain's apparent deep (layered, hierarchical) architecture.
A good overview of the theory of Deep Learning theory is
[Learning Deep Architectures for AI](http://www.iro.umontreal.ca/~bengioy/papers/ftml_book.pdf)

For a more informal introduction, see the following videos by Geoffrey Hinton and Andrew Ng.

* [The Next Generation of Neural Networks](http://www.youtube.com/watch?v=AyzOUbkUf3M) (Hinton, 2007)
* [Recent Developments in Deep Learning](http://www.youtube.com/watch?v=VdIURAu1-aU) (Hinton, 2010)
* [Unsupervised Feature Learning and Deep Learning](http://www.youtube.com/watch?v=ZmNOAtZIgIk) (Ng, 2011)

If you use this toolbox in your research please cite:

[Prediction as a candidate for learning deep hierarchical models of data](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6284) (Palm, 2012)

Directories included in the toolbox
-----------------------------------

`NN/`   - A library for Feedforward Backpropagation Neural Networks

`CNN/`  - A library for Convolutional Neural Networks

`DBN/`  - A library for Deep Belief Networks

`SAE/`  - A library for Stacked Auto-Encoders

`CAE/` - A library for Convolutional Auto-Encoders

`util/` - Utility functions used by the libraries

`data/` - Data used by the examples

`tests/` - unit tests to verify toolbox is working

For references on each library check REFS.md

Example: Deep Belief Network
---------------------
```matlab
%%  train a 100-100-100 DBN and use its weights to initialize a FFNN
dbn.sizes = [100 100 100];      % Number of neurons in each layer
opts.numepochs =   5;           % Number of full sweeps through data
opts.batchsize = 100;           % Mini-batch size
opts.momentum  =   0;           % Momentum (0 = none)
opts.alpha     =   1;           % Learning rate
dbn = dbnsetup(dbn, train_x, opts);     % Init network
dbn = dbntrain(dbn, train_x, opts);     % Train network

% Use the parameters learned from pre-training to initialize a FFNN to be used for classification
nn.size = [100 100 100];
nn = nnsetup(nn, train_x, train_y);
for i = 1 : 3
    nn.W{i} = dbn.rbm{i}.W;
    nn.b{i} = dbn.rbm{i}.c;
end

nn.alpha  = 1;
nn.lambda = 1e-4;
opts.numepochs =  10;
opts.batchsize = 100;

nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);

printf('%5.2f% error', 100 * er)
figure; visualize(nn.W{1}', 1);         %Visualize the weights in the lowest layer
```

Example: Stacked Denoising Auto Encoder
---------------------
```matlab
%%  ex1 train a 100-100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
sae.size = [100 100];
sae = saesetup(sae, train_x);

sae.ae{1}.alpha = 1;      % Learning rate
sae.ae{1}.inl   = 0.5;    % fraction of zero-masked inputs (the noise)
sae.ae{2}.alpha = 1;      % Learning rate
sae.ae{2}.inl   = 0.5;    % fraction of zero-masked inputs (the noise)

opts.numepochs =   5;     % Number of full sweeps through data
opts.batchsize = 100;     % Mini-batch size

sae = saetrain(sae, train_x, opts);     % Do the pre-training

%  use the SDAE to initialize a FFNN
nn.size = [100 100]; 
nn = nnsetup(nn, train_x, train_y);

nn.W{1} = sae.ae{1}.W{1};
nn.b{1} = sae.ae{1}.b{1};
nn.W{2} = sae.ae{2}.W{1};
nn.b{2} = sae.ae{2}.b{1};
nn.lambda = 1e-5;   %  L2 weight decay
nn.alpha  = 1e-0;   %  Learning rate

opts.numepochs =   5;
opts.batchsize = 100;

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
printf('%5.2f% error', 100 * er); % Display error rate
figure; visualize(nn.W{1}', 1)   %  Visualize the weights
```

Setup
-----

1. Download.
2. addpath(genpath('DeepLearnToolbox'));

Everything is work in progress
------------------------------