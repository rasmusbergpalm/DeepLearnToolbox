clear all; close all; clc;

[pathstr, name, ext] = fileparts(mfilename('fullpath'));
addpath(strcat(pathstr, '/../data'));
addpath(strcat(pathstr, '/../util'));

load mnist_uint8;

train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100-100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
sae.size = [100 100];
sae = saesetup(sae, train_x);

sae.ae{1}.alpha = 1;
sae.ae{1}.inl   = 0.5;   %  fraction of zero-masked inputs (the noise)
sae.ae{2}.alpha = 1;
sae.ae{2}.inl   = 0.5;   %  fraction of zero-masked inputs (the noise)

opts.numepochs =   5;
opts.batchsize = 100;

sae = saetrain(sae, train_x, opts);

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
%disp([num2str(er * 100) '% error']);
printf('%5.2f% error', 100 * er);
figure; visualize(nn.W{1}', 1)   %  Visualize the weights
