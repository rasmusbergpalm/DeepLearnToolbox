function rbm = rbmsetup(inputsize,hiddensize, type, opts)
    %type should be a strings specifying the type of RBM to be used.
    % 'gb'= Gaussian Bernoulli 'bb' = Bernoulli Bernoulli. 
    % Be aware that Gaussian Bernoulli RBMs are comparitively unstable and require a learning rate ~1/10th that of a Bernoulli Bernoulli RBM (See https://www.cs.toronto.edu/~hinton/absps/guideTR.pdf)
        rbm.type = type;
        rbm.alpha    = opts.alpha;
        rbm.momentum = opts.momentum;
        
        rbm.numepochs = opts.numepochs;
        
        rbm.W  = zeros(hiddensize, inputsize);
        rbm.W  = normrnd(rbm.W ,0.01); 
        rbm.vW = zeros(hiddensize, inputsize);

        rbm.b  = zeros(inputsize, 1); 
        rbm.vb = zeros(inputsize, 1);

        rbm.c  = zeros(hiddensize, 1);
        rbm.vc = zeros(hiddensize, 1);
end
