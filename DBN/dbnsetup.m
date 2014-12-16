function dbn = dbnsetup(dbn, x, opts, types)
    %types should be a cell array of strings specifying the type of RBM to be used.
    % 'gb'= Gaussian Bernoulli 'bb' = Bernoulli Bernoulli. A type specifier is needed for each layer.
    % Be aware that Gaussian Bernoulli RBMs are comparitively unstable and require a learning rate ~1/10th that of a Bernoulli Bernoulli RBM (See https://www.cs.toronto.edu/~hinton/absps/guideTR.pdf)
     
    n = size(x, 2);
    dbn.sizes = [n, dbn.sizes];
    
    if nargin<4 || length(types)<length(dbn.sizes)-1
       types = repmat({'bb'},1,length(dbn.sizes)-1);
    end
    

    for u = 1 : numel(dbn.sizes) - 1
        dbn.rbm{u} = rbmsetup(dbn.sizes(u),dbn.sizes(u + 1), types{u}, opts);
    end
end
