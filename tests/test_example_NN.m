function test_example_NN
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%% ex1 vanilla neural net
rng(0);
nn = nnsetup([784 100 10]);
opts.numepochs =  1;   %  Number of full sweeps through data
opts.batchsize = 100;  %  Take a mean gradient step over this many samples
[nn,L] = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.08, 'Too big error');


%% ex2 neural net with L2 weight decay
rng(0);
nn = nnsetup([784 100 10]);

nn.weightPenaltyL2 = 1e-4;  %  L2 weight decay
opts.numepochs =  1;        %  Number of full sweeps through data
opts.batchsize = 100;       %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');


%% ex3 neural net with dropout
rng(0);
nn = nnsetup([784 100 10]);

nn.dropoutFraction = 0.5;   %  Dropout fraction 
opts.numepochs =  1;        %  Number of full sweeps through data
opts.batchsize = 100;       %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.16, 'Too big error');
