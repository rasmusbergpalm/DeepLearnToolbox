function [nn, L]  = nntrain(nn, train_x, train_y, opts, val_x, val_y)
%NNTRAIN trains a neural net
% [nn, L] = nnff(nn, x, y, opts) trains the neural network nn with input x and
% output y for opts.numepochs epochs, with minibatches of size
% opts.batchsize. Returns a neural network nn with updated activations,
% errors, weights and biases, (nn.a, nn.e, nn.W, nn.b) and L, the sum
% squared error for each training minibatch.

assert(isfloat(train_x), 'train_x must be a float');
assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')

loss.train.e               = [];
loss.train.e_frac          = [];
if nargin == 4 % training data
    opts.validation = 0;
    
else  %training data and validation data
    opts.validation = 1;
    loss.val.e                 = [];
    loss.val.e_frac            = [];
end

if ~isfield(opts,'plot')
    fhandle = [];
elseif opts.plot == 1
    fhandle = figure();
else
    fhandle = [];
end


m = size(train_x, 1);

if nn.normalize_input==1
    [train_x, mu, sigma] = zscore(train_x);
    nn.normalizeMean = mu;
    sigma(sigma==0) = 0.0001;%this should be very small value.
    nn.normalizeStd  = sigma;
end


batchsize = opts.batchsize;
numepochs = opts.numepochs;

numbatches = m / batchsize;

assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

L = zeros(numepochs*numbatches,1);
n = 1;
for i = 1 : numepochs
    tic;
    
    kk = randperm(m);
    for l = 1 : numbatches
        batch_x = train_x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        
        %Add noise to input (for use in denoising autoencoder)
        if(nn.inputZeroMaskedFraction ~= 0)
            batch_x = batch_x.*(rand(size(batch_x))>nn.inputZeroMaskedFraction);
        end
        
        batch_y = train_y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        
        nn = nnff(nn, batch_x, batch_y);
        nn = nnbp(nn);
        nn = nnapplygrads(nn);
        
        L(n) = nn.L;
        
        n = n + 1;
    end
    
    t = toc;
    
    if ishandle(fhandle)
        
        if opts.validation == 1
            loss = nneval(nn,loss,train_x,train_y,val_x,val_y);
        else
            loss = nneval(nn,loss,train_x,train_y);
        end
        
        nnupdatefigures(nn,fhandle,loss,opts,i);
    end
        
    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1))))]);
    
end
end

