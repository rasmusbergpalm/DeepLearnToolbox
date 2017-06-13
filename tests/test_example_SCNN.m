% function test_example_SCNN
load mnist_uint8;

train_x = double(reshape(train_x',28,28,60000))/255;
train_x_sp = tensor2spcell(train_x);
test_x = double(reshape(test_x',28,28,10000))/255;
test_x_sp = tensor2spcell(test_x);
train_y = double(train_y');
test_y = double(test_y');

%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

rand('state',0)

scnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};


opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 1;

scnn = scnnsetup(scnn, train_x_sp, train_y);
scnn = scnntrain(scnn, train_x_sp, train_y, opts);

[er, bad] = scnntest(scnn, test_x_sp, test_y);

%plot mean squared error
figure; plot(scnn.rL);
assert(er<0.12, 'Too big error');
