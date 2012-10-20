clear all; close all; clc;
load mnist_uint8;

train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
sae = saesetup([784 100]);

sae.ae{1}.alpha                     = 0.5;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;

opts.numepochs =   5;
opts.batchsize = 100;

sae = saetrain(sae, train_x, opts);

figure; visualize(sae.ae{1}.W{1}', 1)   %  Visualize the weights

%  use the SDAE to initialize a FFNN
nn = nnsetup([784 100 10]);

nn.W{1} = sae.ae{1}.W{1};
nn.b{1} = sae.ae{1}.b{1};
nn.lambda = 1e-5;   %  L2 weight decay
nn.alpha  = 1e-0;   %  Learning rate

opts.numepochs =   5;
opts.batchsize = 100;

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %  Visualize the weights
