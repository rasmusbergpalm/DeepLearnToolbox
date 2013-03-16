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
rng(0);
nn = nnsetup([784 100 10]);
nn.numepochs =  1;   %  Number of full sweeps through data
nn.batchsize = 100;  %  Take a mean gradient step over this many samples
nn.momentum = 0;
nn.dropout = 0;
nn.weightPenaltyL2 = 0;
opts=[];
[nn, L] = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);

assert(er < 0.1, 'Too big error');

% Make an artificial one and verify that we can predict it
x = zeros(1,28,28);
x(:, 14:15, 6:22) = 1;
x = reshape(x,1,28^2);
figure; visualize(x');
predicted = nnpredict(nn,x)-1;
title(['NN prediction: 1 == ',num2str(predicted)]);

assert(predicted == 1,'Prediction is wrong');

%% ex2 neural net with L2 weight decay
rng(0);
nn = nnsetup([784 100 10]);
nn.weightPenaltyL2 = 1e-4;  %  L2 weight decay
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex3 neural net with dropout
rng(0);
nn = nnsetup([784 100 10]);
nn.dropout = 0.5;   %  Dropout fraction 
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');

%% ex4 neural net with sigmoid activation function
rng(0);
nn = nnsetup([784 100 10]);
nn.activation_function = 'sigm';    %  Sigmoid activation function
nn.learningRate = 1;                %  Sigm require a lower learning rate
nn.numepochs =  1;                %  Number of full sweeps through data
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.3, 'Too big error');

%% ex5 plotting functionality
rng(0);
nn = nnsetup([784 20 10]);
nn.output              = 'softmax';    %  use softmax output
nn.batchsize         = 1000;         %  Take a mean gradient step over this many samples
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

rng(0);
nn                      = nnsetup([784 20 10]);     
nn.output               = 'softmax';                   %  use softmax output
nn.batchsize          = 1000;                        %  Take a mean gradient step over this many samples
opts.plot               = 1;                           %  enable plotting
nn = nntrain(nn, tx, ty, opts, vx, vy);                %  nntrain takes validation set as last two arguments (optionally)

[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.1, 'Too big error');