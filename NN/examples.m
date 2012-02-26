clear all; close all; clc;
addpath('../data');
addpath('../util');

load mnist_uint8;

train_x = double(train_x)/255;
train_y = double(train_y);
test_x = double(test_x)/255;
test_y = double(test_y);

%% ex1: Using 100 hidden units, learn to recognize handwritten digits
nn.size = [100];       %Vector of number of hidden units. It will automatically add input and output units
nn = nnsetup(nn, train_x, train_y);

nn.lambda = 1e-5;      %L2 weight decay
nn.alpha = 1e-0;       %Learning rate
opts.numepochs = 30;    %Number of full sweeps through data
opts.batchsize = 100;   %Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er*100) '% error']);
figure;visualize(nn.W{1}',1) %Visualize the weights

%% ex2: Using 100-50 hidden units, learn to recognize handwritten digits
nn.size = [100 50];       %Vector of number of hidden units. It will automatically add input and output units
nn = nnsetup(nn, train_x, train_y);

nn.lambda = 1e-5;      %L2 weight decay
nn.alpha = 1e-0;       %Learning rate
opts.numepochs = 30;    %Number of full sweeps through data
opts.batchsize = 100;   %Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er*100) '% error']);
figure;visualize(nn.W{1}',1) %Visualize the weights