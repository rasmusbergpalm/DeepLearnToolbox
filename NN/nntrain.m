function [nn, L] = nntrain(nn, x, y, opts)
%NNTRAIN trains a neural net
% [nn, L] = nnff(nn, x, y, opts) trains the neural network nn with input x and 
% output y for opts.numepochs epochs, with minibatches of size
% opts.batchsize. Returns a neural network nn with updated activations,
% errors, weights and biases, (nn.a, nn.e, nn.W, nn.b) and L, the sum 
% squared error for each training minibatch.

    assert(isfloat(x), 'x must be a float');
    m = size(x, 1);
    
    batchsize = opts.batchsize;
    numepochs = opts.numepochs;

    numbatches = m / batchsize;

    assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

    L = zeros(numepochs*numbatches);
    n = 1;
    for i = 1 : numepochs
        tic;

        kk = randperm(m);
        for l = 1 : numbatches
            batch_x = x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
            
            %Add noise to input (for use in denoising autoencoder)
            if(nn.inputZeroMaskedFraction ~= 0)
                batch_x = batch_x.*(rand(size(batch_x))>nn.inputZeroMaskedFraction);
            end
            
            batch_y = y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
            
            nn = nnff(nn, batch_x, batch_y);
            nn = nnbp(nn);            
            nn = nnapplygrads(nn);

            L(n) = nn.L;
            
            n = n + 1;
        end

        t = toc;
        
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1))))]);
        
    end
end

