function nn = nn_online_step_train(nn, sample_x, sample_y, opts)
%NN_ONLINE_STEP_TRAIN  online step trains a neural net
% nn = nn_online_step_train(nn, train_x, train_y, opts) trains the neural network nn online
% with input sample_x and output sample_y
% and this can be done with minibatches of size opts.batchsize.
% Returns a neural network nn with online step updated activations,
% weights and biases, (nn.a, nn.W, nn.b)

assert(nargin == 4,'number ofinput arguments must be 4 ')

m = size(sample_y, 1);

batchsize = opts.batchsize;

numbatches = m / batchsize;

assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

kk = randperm(m);
for l = 1 : numbatches
    batch_x = sample_x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
    
    %Add noise to input (for use in denoising autoencoder)
    if(nn.inputZeroMaskedFraction ~= 0)
        batch_x = batch_x.*(rand(size(batch_x))>nn.inputZeroMaskedFraction);
    end
    
    batch_y = sample_y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
    
    nn = nnff(nn, batch_x, batch_y);
    nn = nnbp(nn);
    nn = nnapplygrads(nn);
end

nn.learningRate = nn.learningRate * nn.scaling_learningRate;




