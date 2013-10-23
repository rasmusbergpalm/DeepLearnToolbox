function [nn, lossPerBatch]  = nntrain(nn, train_x, train_y, opts, val_x, val_y)
%NNTRAIN trains a neural net
% [nn, lossPerBatch] = nnff(nn, x, y, opts) trains the neural network nn with input x and
% output y for opts.numepochs epochs, with minibatches of size
% opts.batchsize. Returns a neural network nn with updated activations,
% errors, weights and biases, (nn.a, nn.e, nn.W, nn.b) and lossPerBatch, the sum
% squared error for each training minibatch.

assert(isfloat(train_x), 'train_x must be a float');
assert(nargin == 4 || nargin == 6,'number of input arguments must be 4 or 6')


loss.train.e               = []; %Collection of errors (mean squared error of output activations after a feedforward pass and the reference activations) after all minibatches have been applied.
loss.train.e_frac          = []; %Collection of misclassification rates after all minibatches have been applied. Only computed for 'softmax' output.
loss.val.e                 = []; %Same as above, but for validation data.
loss.val.e_frac            = []; %Same as above, but for validation data.

opts.validation = 0;
if nargin == 6
    opts.validation = 1;
end

fhandle = [];
if isfield(opts,'plot') && opts.plot == 1
    fhandle = figure();
end

m = size(train_x, 1);

batchsize = opts.batchsize;
numepochs = opts.numepochs;

numbatches = m / batchsize;

assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

%checking and initialising some options
runUntilThresholdIsReached = opts.numepochs < 1;
if(runUntilThresholdIsReached)
	lossPerBatch = zeros(numepochs*numbatches,1);
else
	lossPerBatch = zeros(0,1);
end;
if(!isfield(opts,"threshold")) opts.threshold = 0.01; end;

iterator = 0;
batchNumber = 1;
oldError = 0; currentError = inf;

notDone = true; %Hack to substitute do-until, which is absent an Matlab.
while(notDone)
	oldError = currentError;
	iterator++;
	if(!runUntilThresholdIsReached) lossPerBatch = [lossPerBatch;zeros(numbatches,1)]; end
%for i = 1 : numepochs
    tic;
    
    kk = randperm(m);
    for batchIterator = 1 : numbatches
        batch_x = train_x(kk((batchIterator - 1) * batchsize + 1 : batchIterator * batchsize), :);
        
        %Add noise to input (for use in denoising autoencoder)
        if(nn.inputZeroMaskedFraction ~= 0)
            batch_x = batch_x.*(rand(size(batch_x))>nn.inputZeroMaskedFraction);
        end
        
        batch_y = train_y(kk((batchIterator - 1) * batchsize + 1 : batchIterator * batchsize), :);
        
        nn = nnff(nn, batch_x, batch_y);
        nn = nnbp(nn);
        nn = nnapplygrads(nn);
        
        lossPerBatch(batchNumber) = nn.lossPerBatch;
        batchNumber++;
    end
    
    t = toc;

    if opts.validation == 1
        loss = nneval(nn, loss, train_x, train_y, val_x, val_y);
        currentError = loss.val.e(end);
        str_perf = sprintf('; Full-batch train mse = %f, val mse = %f', loss.train.e(end), loss.val.e(end));
    else
        loss = nneval(nn, loss, train_x, train_y);
        currentError = loss.train.e(end);
        str_perf = sprintf('; Full-batch train err = %f', loss.train.e(end));
    end
    if ishandle(fhandle)
        nnupdatefigures(nn, fhandle, loss, opts, i);
    end

    if(opts.verbosity >= 1)
        if(runUntilThresholdIsReached)
            disp(['epoch ' num2str(iterator) '. Took ' num2str(t) ' seconds' '. Mini-batch mean squared error on training set is ' num2str(mean(lossPerBatch((batchNumber-numbatches):(batchNumber-1)))) str_perf]);
        else
            disp(['epoch ' num2str(iterator) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mini-batch mean squared error on training set is ' num2str(mean(lossPerBatch((batchNumber-numbatches):(batchNumber-1)))) str_perf]);
        end%if
    end%if

    nn.learningRate = nn.learningRate * nn.scaling_learningRate;
    if runUntilThresholdIsReached
        done = (oldError - currentError) < opts.threshold; %Condition for running to threshold
    else
        done = iterator >= opts.numepochs; %Condition for iterating
    end%if
    notDone = not(done);
end%while

end%function

