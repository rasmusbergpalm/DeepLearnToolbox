function rbm = rbmtrain(rbm, x, opts)
    lr = rbm.lr;
    m = size(x,1);
    numbatches = m/opts.batchsize;
    if(rem(numbatches,1)~=0)
        error('numbatches not integer');
    end
    
    for i=1:opts.numepochs
        kk = randperm(m);
        err = 0;
        for l=1:numbatches
            batch = x(kk((l-1)*opts.batchsize+1:l*opts.batchsize),:);
        
            v1 = batch;
            h1 = sigmrnd(repmat(rbm.c',opts.batchsize,1) + v1*rbm.W');
            v2 = sigmrnd(repmat(rbm.b',opts.batchsize,1) + h1*rbm.W);
            h2 = sigmrnd(repmat(rbm.c',opts.batchsize,1) + v2*rbm.W');

            c1 = h1'*v1;
            c2 = h2'*v2;

            rbm.W = rbm.W + lr*(c1-c2)/opts.batchsize;
            rbm.b = rbm.b + lr*sum(v1-v2)'/opts.batchsize;
            rbm.c = rbm.c + lr*sum(h1-h2)'/opts.batchsize;
            
            err = err + sum(sum((v1-v2).^2));
        end
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)  '. Average reconstruction error is: ' num2str(err/numbatches)]);
    end
end