function rbm = rbmtrain(rbm, x, opts)
    assert(isfloat(x), 'x must be a float');
    
    assert(strcmp(rbm.type,'gb') || all(x(:)>=0) && all(x(:)<=1), 'all data in x must be in [0:1], unless gb rbm');
    m = size(x, 1);
    
    if (~mod(m,opts.batchsize))
       warning('WRX:BATCH','training data could not be divided into even batchs. Some data was disguarded'); 
    end
    
    numbatches = floor(m / opts.batchsize);
    
    
    
    if(strcmp(rbm.type,'gb'))
        v = var(x);
        assert(all(v(v~=0)<=1+0.01) && all(v(v~=0)>=1-0.01), 'for gb rbm: x must have featurewise variance of 0 or 1');
    else 
        %assume type='bb'
        assert(all(x(:)>=0) && all(x(:)<=1), 'for bb rbm: all data in x must be in [0:1]');
    end
    
    for i = 1 : rbm.numepochs
        kk = randperm(m);
        err = 0;
        for l = 1 : numbatches
            batch = x(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize), :);
            
            v1 = batch;
            h1 = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + v1 * rbm.W');
            
            if strcmp(rbm.type,'gb')
                %Then is Gaussian Bernboillim so sample from normal to get
                % visible
                mu = (repmat(rbm.b', opts.batchsize, 1) + h1 * rbm.W);
                v2 = normrnd(mu,1.00);
            else
                %assume it is bernoilli bernoili so sample from sigmoid
                v2 = sigmrnd(repmat(rbm.b', opts.batchsize, 1) + h1 * rbm.W);
            end
            
            h2 = sigm(repmat(rbm.c', opts.batchsize, 1) + v2 * rbm.W');

            c1 = h1' * v1;
            c2 = h2' * v2;

            rbm.vW = rbm.momentum * rbm.vW + rbm.alpha * (c1 - c2)     / opts.batchsize;
            rbm.vb = rbm.momentum * rbm.vb + rbm.alpha * sum(v1 - v2)' / opts.batchsize;
            rbm.vc = rbm.momentum * rbm.vc + rbm.alpha * sum(h1 - h2)' / opts.batchsize;

            rbm.W = rbm.W + rbm.vW;
            rbm.b = rbm.b + rbm.vb;
            rbm.c = rbm.c + rbm.vc;

            err = err + sum(sum((v1 - v2) .^ 2)) / opts.batchsize;
        end
        
        disp(['epoch ' num2str(i) '/' num2str( rbm.numepochs)  '. Average reconstruction error is: ' num2str(err / numbatches)]);
        
    end
end
