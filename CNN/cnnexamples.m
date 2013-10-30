close all; clc;
load mnist_uint8;

xsize = [28 28];
train_x = double(reshape(train_x', xsize(1), xsize(2), 60000))/255;
test_x = double(reshape(test_x', xsize(1), xsize(2), 10000))/255;
train_y = double(train_y);
test_y = double(test_y);

%% ex1 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error
cnn.alpha = 1;
cnn.batchsize = 50;
cnn.numepochs = 1;

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', [5 5]) %convolution layer
    struct('type', 's', 'scale', [2 2]) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', [5 5]) %convolution layer
    struct('type', 's', 'scale', [2 2]) %subsampling layer    
};
cnn = cnnsetup(cnn, xsize, size(train_y, 2));
cnn = cnntrain(cnn, train_x, train_y);
plot(cnn.rL);
err = cnntest(cnn, test_x, test_y);
disp([num2str(err*100) '% error']);
