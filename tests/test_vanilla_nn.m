function test_vanilla_nn
rng(0);
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

nn = nnsetup([784 100 10]);

nn.learningRate = 1;   %  Learning rate
opts.numepochs =  1;   %  Number of full sweeps through data
opts.batchsize = 100;  %  Take a mean gradient step over this many samples
opts.silent = 1;
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');