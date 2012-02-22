clear all; close all; clc;
addpath('../data');
addpath('../util');

load mnist_uint8;

train_x = double(train_x)/255;
train_y = double(train_y);
test_x = double(test_x)/255;
test_y = double(test_y);

%% ex1: Using 100 hidden units, learn to recognize handwritten digits
net.size = [100];       %Vector of number of hidden units. It will automatically add input and output units
net = nnsetup(net, train_x, train_y);

net.lambda = 1e-5;      %L2 weight decay
net.alpha = 1e-0;       %Learning rate
opts.numepochs = 30;    %Number of full sweeps through data
opts.batchsize = 100;   %Take a mean gradient step over this many samples
net = nntrain(net, train_x, train_y, opts);

[er, bad] = nntest(net, test_x, test_y);
disp([num2str(er*100) '% error']);
figure;visualize(net.W{1}',1) %Visualize the weights

%% ex2: Using 100-50 hidden units, learn to recognize handwritten digits
net.size = [100 50];       %Vector of number of hidden units. It will automatically add input and output units
net = nnsetup(net, train_x, train_y);

net.lambda = 1e-5;      %L2 weight decay
net.alpha = 1e-0;       %Learning rate
opts.numepochs = 30;    %Number of full sweeps through data
opts.batchsize = 100;   %Take a mean gradient step over this many samples
net = nntrain(net, train_x, train_y, opts);

[er, bad] = nntest(net, test_x, test_y);
disp([num2str(er*100) '% error']);
figure;visualize(net.W{1}',1) %Visualize the weights

%% ex3: Train a denoising autoencoder (DAE) and use it to initialize the weights for a NN

DAE.size = [100];
DAE = nnsetup(DAE, train_x, train_x);
DAE.lambda = 1e-5;
DAE.alpha = 1e-0;
opts.numepochs = 1;
opts.batchsize = 100;
% This is a bit of a hack so we can apply different noise for each epoch.
% We should apply the noise when selecting the batches really.
for i=1:30
    DAE = nntrain(DAE, train_x.*double(rand(size(train_x))>0.5), train_x, opts);
end


%Use the DAE weights and biases to initialize a standard NN
net.size = [100];
net = nnsetup(net, train_x, train_y);
net.W{1} = DAE.W{1};
net.b{1} = DAE.b{1};

net.lambda = 1e-5;
net.alpha = 1e-0;
opts.numepochs = 30;
opts.batchsize = 100;
net = nntrain(net, train_x, train_y, opts);

[er, bad] = nntest(net, test_x, test_y);

disp([num2str(er*100) '% error']);
figure;visualize(DAE.W{1}',1) %Visualize the DAE weights
figure;visualize(net.W{1}',1) %Visualize the NN weights