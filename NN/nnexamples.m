clear all; close all; clc; dbstop if error

[pathstr, name, ext] = fileparts(mfilename('fullpath'));
addpath(strcat(pathstr, '/../data'));
addpath(strcat(pathstr, '/../util'));

load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1: Using 100 hidden units, learn to recognize handwritten digits
nn.size = [100];        %  Vector of number of hidden units. It will automatically add input and output units
nn = nnsetup(nn, train_x, train_y);

nn.lambda = 1e-5;       %  L2 weight decay
nn.alpha  = 1e-0;       %  Learning rate
opts.numepochs =  100;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
%disp([num2str(er * 100) '% error']);
printf('%5.2f% error', 100 * er)
figure; visualize(nn.W{1}', 1)   %  Visualize the weights

%%  ex2: Using 100-50 hidden units, learn to recognize handwritten digits
nn.size = [100 50];    %  Vector of number of hidden units. It will automatically add input and output units
nn = nnsetup(nn, train_x, train_y);

nn.lambda = 1e-5;       %  L2 weight decay
nn.alpha  = 1e-0;       %  Learning rate
opts.numepochs =  30;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
%disp([num2str(er * 100) '% error']);
printf('%5.2f% error', 100 * er)
figure; visualize(nn.W{1}', 1)   %  Visualize the weights

%%  ex3: Train a denoising autoencoder (DAE) and use it to initialize the weights for a NN

DAE.size = [100];
DAE = nnsetup(DAE, train_x, train_x);
DAE.lambda = 1e-5;
DAE.alpha  = 1e-0;
opts.numepochs =   1;
opts.batchsize = 100;
%  This is a bit of a hack so we can apply different noise for each epoch.
%  We should apply the noise when selecting the batches really.
for i = 1 : 30
    DAE = nntrain(DAE, train_x .* double(rand(size(train_x)) > 0.5), train_x, opts);
end

%  Use the DAE weights and biases to initialize a standard NN
nn.size = [100];
nn = nnsetup(nn, train_x, train_y);
nn.W{1} = DAE.W{1};
nn.b{1} = DAE.b{1};

nn.lambda = 1e-5;
nn.alpha  = 1e-0;
opts.numepochs =  30;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);

%disp([num2str(er * 100) '% error']);
printf('%5.2f% error', 100 * er)
figure; visualize(DAE.W{1}', 1)   %  Visualize the DAE weights
figure; visualize(nn.W{1}',  1)   %  Visualize the NN weights
