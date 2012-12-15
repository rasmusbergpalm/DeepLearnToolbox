
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

Setup
-----

1. Download.
2. addpath(genpath('DeepLearnToolbox'));

Everything is work in progress
------------------------------

Example: Deep Belief Network
---------------------
```matlab

clear all; close all; clc;

load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100 hidden unit RBM and visualize its weights
dbn.sizes = [100];
opts.numepochs =   5;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);
figure; visualize(dbn.rbm{1}.W', 1);   %  Visualize the RBM weights

%%  ex2 train a 100-100-100 DBN and use its weights to initialize a NN
dbn.sizes = [100 100 100];
opts.numepochs =   5;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);

nn = dbnunfoldtonn(dbn, 10);

nn.learningRate  = 1;
nn.weightPenaltyL2 = 1e-4;
opts.numepochs =  10;
opts.batchsize = 100;

nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);

disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1);

```


Example: Stacked Auto-Encoders
---------------------
```matlab

clear all; close all; clc;
load mnist_uint8;

train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
sae = saesetup([784 100]);

sae.ae{1}.learningRate              = 0.5;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;

opts.numepochs =   5;
opts.batchsize = 100;

sae = saetrain(sae, train_x, opts);

figure; visualize(sae.ae{1}.W{1}', 1)   %  Visualize the weights

%  use the SDAE to initialize a FFNN
nn = nnsetup([784 100 10]);

nn.W{1} = sae.ae{1}.W{1};
nn.b{1} = sae.ae{1}.b{1};
nn.weightPenaltyL2 = 1e-5;   %  L2 weight decay
nn.learningRate  = 1e-0;   %  Learning rate

opts.numepochs =   5;
opts.batchsize = 100;

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %  Visualize the weights

```


Example: Convolutional Neural Nets
---------------------
```matlab

clear all; close all; clc;
addpath('../data');
load mnist_uint8;

train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');

%% ex1 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 1;

cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
plot(cnn.rL);
%show test error
disp([num2str(er*100) '% error']);

```


Example: Neural Networks
---------------------
```matlab

clear all; close all; clc; dbstop if error
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1: Using 100 hidden units, learn to recognize handwritten digits
nn = nnsetup([784 100 10]);

nn.learningRate = 1;    %  Learning rate
opts.numepochs =  1;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %  Visualize the weights

%%  ex2: Using 100-50 hidden units, learn to recognize handwritten digits
nn = nnsetup([784 100 50 10]);

nn.weightPenaltyL2 = 1e-5;       %  L2 weight decay
nn.learningRate  = 1;       %  Learning rate
opts.numepochs =  1;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %Visualize the weights

%% ex3 using 100 hidden units w. dropout
nn = nnsetup([784 100 10]);
nn.dropoutFraction = 0.5;

nn.learningRate  = 1;       %  Learning rate
opts.numepochs = 1;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %Visualize the weights

```


