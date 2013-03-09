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
[nn, L] = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);

assert(er < 0.08, 'Too big error');

% Make an artificial one and verify that we can predict it
x = zeros(1,28,28);
x(:, 14:15, 6:22) = 1;
x = reshape(x,1,28^2);
figure; visualize(x');
predicted = nnpredict(nn,x)-1;

assert(predicted == 1);
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
assert(er < 0.1, 'Too big error');

%% ex4 neural net with sigmoid activation function, and without normalizing inputs
rng(0);
nn = nnsetup([784 100 10]);

nn.activation_function = 'sigm';    %  Sigmoid activation function
nn.normalize_input = 0;             %  Don't normalize inputs
nn.learningRate = 1;                %  Sigm and non-normalized inputs require a lower learning rate
opts.numepochs =  1;                %  Number of full sweeps through data
opts.batchsize = 100;               %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex5 plotting functionality
rng(0);
nn = nnsetup([784 20 10]);
nn.normalize_input     = 1; 
nn.activation_function = 'tanh_opt';        %  Sigmoid activation function
nn.normalize_input     = 1;            
nn.learningRate        = 0.1;          
opts.numepochs         = 20;            %  Number of full sweeps through data
opts.batchsize         = 100;           %  Take a mean gradient step over this many samples
opts.plot              = 1;             %  enable plotting

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex6 neural net with sigmoid and plotting of validation and training error

%create validation set
load mnist_uint8;

val_x   = double(train_x(1:10000,:)) / 255;
train_x = double(train_x(10001:end,:)) / 255;
test_x  = double(test_x)/255;

val_y   = double(train_y(1:10000,:));
train_y = double(train_y(10001:end,:));
test_y  = double(test_y);


rng(0);
nn                      = nnsetup([784 20 10]);
nn.normalize_input      = 0;
nn.activation_function  = 'sigm';
nn.output               = 'softmax';
nn.learningRate         = 0.1;
opts.numepochs          = 20;        %  Number of full sweeps through data
opts.batchsize          = 100;       %  Take a mean gradient step over this many samples
opts.plot               = 1;          %  enable plotting
nn = nntrain(nn, train_x, train_y, opts,val_x,val_y);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.06, 'Too big error');