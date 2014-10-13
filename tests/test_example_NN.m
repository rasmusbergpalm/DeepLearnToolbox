function test_example_NN
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

% normalize
[train_x, mu, sigma] = zscore(train_x);
test_x = normalize(test_x, mu, sigma);

%% ex1 vanilla neural net
rand('state',0)
nn = nnsetup([784 100 10]);
opts.numepochs =  1;   %  Number of full sweeps through data
opts.batchsize = 100;  %  Take a mean gradient step over this many samples
[nn, L] = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);

assert(er < 0.08, 'Too big error');

%% ex2 neural net with L2 weight decay
rand('state',0)
nn = nnsetup([784 100 10]);

nn.weightPenaltyL2 = 1e-4;  %  L2 weight decay
opts.numepochs =  1;        %  Number of full sweeps through data
opts.batchsize = 100;       %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');


%% ex3 neural net with dropout
rand('state',0)
nn = nnsetup([784 100 10]);

nn.dropoutFraction = 0.5;   %  Dropout fraction 
opts.numepochs =  1;        %  Number of full sweeps through data
opts.batchsize = 100;       %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex4 neural net with sigmoid activation function
rand('state',0)
nn = nnsetup([784 100 10]);

nn.activation_function = 'sigm';    %  Sigmoid activation function
nn.learningRate = 1;                %  Sigm require a lower learning rate
opts.numepochs =  1;                %  Number of full sweeps through data
opts.batchsize = 100;               %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex5 plotting functionality
rand('state',0)
nn = nnsetup([784 20 10]);
opts.numepochs         = 5;            %  Number of full sweeps through data
nn.output              = 'softmax';    %  use softmax output
opts.batchsize         = 1000;         %  Take a mean gradient step over this many samples
opts.plot              = 1;            %  enable plotting

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex6 neural net with sigmoid activation and plotting of validation and training error
% split training data into training and validation data
vx   = train_x(1:10000,:);
tx = train_x(10001:end,:);
vy   = train_y(1:10000,:);
ty = train_y(10001:end,:);

rand('state',0)
nn                      = nnsetup([784 20 10]);     
nn.output               = 'softmax';                   %  use softmax output
opts.numepochs          = 5;                           %  Number of full sweeps through data
opts.batchsize          = 1000;                        %  Take a mean gradient step over this many samples
opts.plot               = 1;                           %  enable plotting
nn = nntrain(nn, tx, ty, opts, vx, vy);                %  nntrain takes validation set as last two arguments (optionally)

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex7 neural net for regression problem
rand('state',0);
randn('state',0);

% Some invented nonlinear relationships to get 3 noisy output targets
% 1000 records with 10 features
all_x = randn(20000, 10);
all_y = randn(20000, 3) * 0.01;
all_y(:,1) += sum( all_x(:,1:5) .* all_x(:, 3:7), 2 );
all_y(:,2) += sum( all_x(:,5:9) .* all_x(:, 4:8) .* all_x(:, 2:6), 2 );
all_y(:,3) += log( sum( all_x(:,4:8) .* all_x(:,4:8), 2 ) ) * 3.0;

train_x = all_x(1:19000,:);
train_y = all_y(1:19000,:);

test_x = all_x(19001:20000,:);
test_y = all_y(19001:20000,:);

% the constructed data is already normalized, but this is usually best practice:
[train_x, mu, sigma] = zscore(train_x);
test_x = normalize(test_x, mu, sigma);

%% ex7 network setup
nn = nnsetup([10 50 50 3]);
nn.activation_function = 'tanh_opt';    %  tanh_opt activation function
nn.output              = 'linear';      %  linear is usual choice for regression problems
nn.learningRate        = 0.001;         %  Linear output can be sensitive to learning rate
nn.momentum            = 0.95;

opts.numepochs =  20;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
[nn, L] = nntrain(nn, train_x, train_y, opts);

% nnoutput calculates the predicted regression values
predictions = nnoutput( nn, test_x );

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 1.5, 'Too big error');
