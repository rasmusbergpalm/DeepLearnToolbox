clear all; close all; clc; dbstop if error
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1: Using 100 hidden units, learn to recognize handwritten digits
nn = nnsetup([784 100 10]);

nn.lambda = 1e-5;       %  L2 weight decay
nn.alpha  = 1e-0;       %  Learning rate
opts.numepochs =  10;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %  Visualize the weights

%%  ex2: Using 100-50 hidden units, learn to recognize handwritten digits
nn = nnsetup([784 100 50 10]);

nn.lambda = 1e-5;       %  L2 weight decay
nn.alpha  = 1e-0;       %  Learning rate
opts.numepochs =  10;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %Visualize the weights

%% ex3 using 800-800 hidden units w. dropout
nn = nnsetup([784 800 800 10]);
nn.dropoutFraction = 0.5;
nn.alpha  = 1e1;       %  Learning rate
opts.numepochs = 10;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %Visualize the weights
