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

For references on each library check REFS.md

Directories included in the toolbox
-----------------------------------

`NN/`   - A library for Feedforward Backpropagation Neural Networks

`CNN/`  - A library for Convolutional Neural Networks

`DBN/`  - A library for Deep Belief Networks

`SAE/`  - A library for Stacked Auto-Encoders

`SPAE/` - A library for Stacked Convolutional Auto-Encoders

`util/` - Utility functions used by the libraries

`data/` - Data used by the examples

Example
---------------------
```matlab
%% ex1: Using 100 hidden units, learn a feedforward backprop neural net to recognize handwritten digits
nn.size = [100];                          %Vector of number of hidden units. It will automatically add input and output units
nn = nnsetup(nn, train_x, train_y);       %Setup the network
nn.lambda = 1e-5;                         %Add L2 weight decay
nn.alpha = 1e-0;                          %Define learning rate
opts.numepochs = 30;                      %Number of full sweeps through data
opts.batchsize = 100;                     %Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts); %Train the network
[err, bad] = nntest(nn, test_x, test_y);  %Test the network performance
disp([num2str(err*100) '% error']);       %Display error rate
```

Overview of libraries
---------------------

(**Not true yet:**) All libraries have two example "applications", a simlpe one named `example.m` and a more complicated
one named `demo.m`. The simple one just gives an example of how the library is meant to be invoked at the code level,
and the more complicated one demonstrates what the library might be used for and/or is capable of.

Setup
-----

1. Download.
2. addpath(genpath('DeepLearnToolbox'));

Everything is work in progress
------------------------------