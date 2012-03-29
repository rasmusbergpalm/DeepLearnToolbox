clear all; close all;% clc;

do_examples = [1 2 3 4];
do_examples = [1];

[pathstr, name, ext] = fileparts(mfilename('fullpath'));
addpath(strcat(pathstr, '/../data'));
addpath(strcat(pathstr, '/../util'));

load mnist_uint8;

x_train = train_x;
y_train = train_y;
x_test  = test_x;
y_test  = test_y;

x_train = double(x_train) / 255;
x_test  = double(x_test)  / 255;
y_train = double(y_train);
y_test  = double(y_test);

n_x = size(x_train, 2);
n_y = size(y_train, 2);

m_train = size(x_train, 1);
m_test  = size(x_test,  1);

printf('\nThere are %d training examples and %d test examples.\n', m_train, m_test)

%%  ex1: Using 100 hidden units, learn to recognize handwritten digits
if find(do_examples == 1)
    printf('\n===== NN with 36 hidden units. =====\n\n')

    layers = [n_x 36 n_y];
    nn = nninit(layers);

    nn.lambda = 1e-5;       %  L2 weight decay
    nn.alpha  = 1e-0;       %  Learning rate
    nn.rho    = 0.03;
    nn.beta   = 1;
    opts.numepochs = 1000;   %  Number of full sweeps through data
%    opts.numepochs =   1;   %  Number of full sweeps through data
    opts.batchsize = 100;   %  Take a mean gradient step over this many samples
    nn = nntrain(nn, x_train, y_train, opts, x_test, y_test);

    [er, bad] = nntest(nn, x_test, y_test);

    printf('\nError: %5.2f%%\n', 100 * er)

    figure; visualize(nn.W{1}', 1)   %  Visualize the weights
end

%%  ex2: Using 100-50 hidden units, learn to recognize handwritten digits

if find(do_examples == 2)
    printf('\n===== NN with 100-50 hidden units. =====\n\n')

    layers = [n_x 100 50 n_y];
    nn = nninit(layers);

    nn.lambda = 1e-5;       %  L2 weight decay
    nn.alpha  = 1e-0;       %  Learning rate
    opts.numepochs = 100;   %  Number of full sweeps through data
%    opts.numepochs =   1;   %  Number of full sweeps through data
    opts.batchsize = 100;   %  Take a mean gradient step over this many samples

    nn = nntrain(nn, x_train, y_train, opts, x_test, y_test);

    [er, bad] = nntest(nn, x_test, y_test);

    printf('\nError: %5.2f%%\n', 100 * er)

    figure; visualize(nn.W{1}', 1)   %  Visualize the weights
    figure; visualize(nn.W{2}', 1)   %  Visualize the weights
end

%%  ex3: Using 100-50-50 hidden units, learn to recognize handwritten digits

if find(do_examples == 3)
    printf('\n===== NN with 100-64-36 hidden units. =====\n\n')

    layers = [n_x 100 64 36 n_y];

    nn = nninit(layers);

    if 1
      sae = saeinit(layers);

        for u = 2 : nn.n - 1
            sae.ae{u}.alpha = 1;
            sae.ae{u}.inl   = 0.5;   %  fraction of zero-masked inputs (the noise)
        end

        opts.numepochs =  20;
        opts.batchsize = 100;

        sae = saetrain(sae, x_train, opts);

        for i = 2 : nn.n - 1
            nn.W{i - 1} = sae.ae{i}.W{1};
            nn.b{i - 1} = sae.ae{i}.b{1};
        end
    end

    nn.lambda = 1e-5;       %  L2 weight decay
    nn.alpha  = 1e-0;       %  Learning rate
    opts.numepochs = 500;   %  Number of full sweeps through data
    opts.batchsize = 100;   %  Take a mean gradient step over this many samples

    nn = nntrain(nn, x_train, y_train, opts, x_test, y_test);

    [er, bad] = nntest(nn, x_test, y_test);

    printf('\nRecognition error: %5.2f%%\n', 100 * er)

    figure; visualize(nn.W{1}', 1)   %  Visualize the weights
%    figure; visualize(nn.W{2}', 1)   %  Visualize the weights
%    figure; visualize(nn.W{3}', 1)   %  Visualize the weights
end

%%  ex4: Train a denoising autoencoder (DAE) and use it to initialize the weights for a NN

if find(do_examples == 4)
    printf('\n===== DAE with 100 hidden units. =====\n\n')

    layers = [n_x 100 n_x];
    DAE = nninit(layers);

    DAE.lambda = 1e-5;
    DAE.alpha  = 1e-0;
    DAE.beta   = 1e-0;
    DAE.rho    = 0.05;
    opts.numepochs =  10;
    opts.batchsize = 100;

    %  This is a bit of a hack so we can apply different noise for each epoch.
    %  We should apply the noise when selecting the batches really.
%    for i = 1 : 30
    for i = 1 : 30
        DAE = nntrain(DAE, x_train .* double(rand(size(x_train)) > 0.5), x_train, opts, x_test, x_test);
    end

    %  Use the DAE weights and biases to initialize a standard NN

    layers = [n_x 100 49 n_y];
    nn = nninit(layers);

    nn.W{1} = DAE.W{1};
    nn.b{1} = DAE.b{1};

    nn.lambda = 1e-5;
    nn.alpha  = 1e-0;
    opts.numepochs = 4000;
    opts.batchsize =  100;

    nn = nntrain(nn, x_train, y_train, opts, x_test, y_test);

    [er, bad] = nntest(nn, x_test, y_test);

    printf('%5.2f% error\n', 100 * er)

    figure; visualize(DAE.W{1}', 1)   %  Visualize the DAE weights
    figure; visualize(nn.W{1}',  1)   %  Visualize the NN weights
end
