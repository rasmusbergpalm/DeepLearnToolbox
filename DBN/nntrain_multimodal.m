function [nn, L]  = nntrain_multimodal(nn, train_x, train_y, opts, val_x, val_y)

assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')

loss.train.e               = [];
loss.train.e_frac          = [];
loss.val.e                 = [];
loss.val.e_frac            = [];
opts.validation = 0;
if nargin == 6
    opts.validation = 1;
end

fhandle = [];
if isfield(opts,'plot') && opts.plot == 1
    fhandle = figure();
end

m = size(train_x{1}, 1);

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
        for mm=1:length(nn.net)
            batch_x{mm} = train_x{mm}(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        end
                
        
        batch_y = train_y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        
        nn = nnff_mm(nn, batch_x, batch_y);
        nn = nnbp_mm(nn);
        nn = nnapplygrads_mm(nn);
        
        L(n) = nn.L;
        
        n = n + 1;
    end
    
    t = toc;
    
    if ishandle(fhandle)
        if opts.validation == 1
            loss = nneval(nn, loss, train_x, train_y, val_x, val_y);
        else
            loss = nneval(nn, loss, train_x, train_y);
        end
        nnupdatefigures(nn, fhandle, loss, opts, i);
    end
        
    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1))))]);
    nn.learningRate = nn.learningRate * nn.scaling_learningRate;
end
end

