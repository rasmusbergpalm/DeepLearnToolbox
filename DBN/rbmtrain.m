function rbm = rbmtrain(rbm, x, opts)
    assert(isfloat(x), 'x must be a float');
    m = size(x, 1);
    numbatches = m / opts.batchsize;
    
    assert(rem(numbatches, 1) == 0, 'numbatches not integer');

    for i = 1 : opts.numepochs
        kk = randperm(m);
        err = 0;
        tic
        for l = 1 : numbatches
            batch = x(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize), :);
            
            v1 = batch;
            h1 = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + v1 * rbm.W');
            v2 = sigmrnd(repmat(rbm.b', opts.bgatchsize, 1) + h1 * rbm.W);
            h2 = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + v2 * rbm.W');

            c1 = h1' * v1;
            c2 = h2' * v2;
    
             
            momentum=rbm.momentum(1)+(rbm.momentum(2)-rbm.momentum(1))*(i)/ opts.numepochs;
            
            rbm.vW = momentum * rbm.vW + rbm.alpha * (c1 - c2)     / opts.batchsize;
            rbm.vb = momentum * rbm.vb + rbm.alpha * sum(v1 - v2)' / opts.batchsize;
            rbm.vc = momentum * rbm.vc + rbm.alpha * sum(h1 - h2)' / opts.batchsize;

            rbm.W = rbm.W + rbm.vW;
            rbm.b = rbm.b + rbm.vb;
            rbm.c = rbm.c + rbm.vc;

            err = err + sum(sum((v1 - v2) .^ 2)) / opts.batchsize;
        end
        
        time_consumed=toc;
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)...
            '. Average reconstruction error is: ' num2str(err / numbatches) 'time: ' num2str(time_consumed)]);
        
    end
end
