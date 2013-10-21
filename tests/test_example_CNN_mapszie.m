clc;clear;
load('../data/mnist_uint8');
addpath(genpath('..'))

train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');

%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error
%rand('state',0)
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 't', 'outputmaps', 15, 'kernelsize', 5) %convolution layer
    struct('type', 'm', 'scale', 2) %sub sampling layer
    struct('type', 't', 'outputmaps', 20, 'kernelsize', 5) %convolution layer
    struct('type', 'm', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1;
opts.batchsize = 100;
opts.numepochs = 50;
opts.momentum = 0;

cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
figure; plot(cnn.rL);

assert(er<0.12, 'Too big error');
% epoch 50/50
% 1 epoch uses 7.143513e+01 second, softmax loss is: 0.479081 
% er=11.45