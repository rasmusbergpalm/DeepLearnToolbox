function test_cnn_gradients_are_numerically_correct
%squared average kernels
batch_x = rand(28,28,5);
batch_y = rand(10,5);
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, batch_x, batch_y);

cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);

%non squared average kernels
batch_x = rand(28,600,5);
batch_y = rand(10,5);
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, batch_x, batch_y);

cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);