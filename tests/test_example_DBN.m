function test_example_DBN
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100 hidden unit RBM and visualize its weights
rand('state',0)
dbn.sizes = [100];
opts.numepochs =   1;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);
figure; visualize(dbn.rbm{1}.W');   %  Visualize the RBM weights

%%  ex2 train a 100-100 hidden unit DBN and use its weights to initialize a NN
rand('state',0)
%train dbn
dbn.sizes = [100 100];
opts.numepochs =   1;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);

%unfold dbn to nn
nn = dbnunfoldtonn(dbn, 10);
nn.activation_function = 'sigm';

%train nn
opts.numepochs =  1;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
fprintf('dbn ex2 er:%f\n', er);
assert(er < 0.10, 'Too big error');


%%  ex3 train a 100-100 hidden unit DBN, with a gaussian input layer and use its weights to initialize a NN, with a softmax output
rand('state',0)

% normalize Inputs (the Gaussian input layer requires unit variance)
[train_x, mu, sigma] = zscore(train_x);
test_x = normalize(test_x, mu, sigma);


%train dbn
dbn.sizes = [100 100];
opts.numepochs =   1;
opts.batchsize = 100;
opts.momentum  =   0.9;
opts.alpha     =   0.1;   %set default for all layers
dbn = dbnsetup(dbn, train_x, opts,  {'gb','bb'});
dbn.rbm{1}.alpha = 0.003; %Gaussian RBMs are unstable for large learning rates, so drop this down abit compaired to other layers.

dbn = dbntrain(dbn, train_x, opts);

%unfold dbn to nn
nn = dbnunfoldtonn(dbn, 10);
nn.activation_function = 'sigm';
nn.output = 'softmax';     %  use softmax output

%train nn
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
fprintf('dbn ex3 er:%f\n', er);
assert(er < 0.10, 'Too big error');


