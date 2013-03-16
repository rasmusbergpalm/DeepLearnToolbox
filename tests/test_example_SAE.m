function test_example_SAE
%%
load mnist_uint8;

train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);
opts=[];
%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
rng(0);
sae = saesetup([784 100]);
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.alpha              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
sae.numepochs =   10; % for Denoising we need to do more runs
sae.batchsize = 100;
sae = saetrain(sae, train_x, opts);
visualize(sae.ae{1}.W{1}(:,2:end)')
title('SAE weights visualization (100 hid.units)');

% Use the SDAE to initialize a FFNN
nn = ffnnsetup([784 100 10]);
nn.activation_function              = 'sigm';
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
nn.numepochs =   5;
nn.batchsize = 100;
nn.alpha=0.5;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.08, 'Too big error');

%% ex2 train a 100-100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
rng(0);
sae = saesetup([784 100 100]);
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.alpha                     = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;

sae.ae{2}.activation_function       = 'sigm';
sae.ae{2}.alpha                     = 1;
sae.ae{2}.inputZeroMaskedFraction   = 0.5;

sae.numepochs =   5; % denoising
sae.batchsize = 100;
sae = saetrain(sae, train_x, opts);
visualize(sae.ae{1}.W{1}(:,2:end)')
title('SAE 100x100 units, layer 2');

% Use the SDAE to initialize a FFNN
nn = ffnnsetup([784 100 100 10]);
nn.activation_function              = 'sigm';
nn.alpha                            = 1;

%add pretrained weights
nn.W{1} = sae.ae{1}.W{1};
nn.W{2} = sae.ae{2}.W{1};

% Train the FFNN
nn.numepochs =   2;
nn.batchsize = 100;
nn.alpha = 0.5; % just SOFT fine-tuning, or you break pretrained knowledge
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');
