function rbm = rbmtrain(rbm, x, opts)
    assert(isfloat(x), 'x must be a float');
    m = size(x, 1);
    numbatches = m / opts.batchsize;
    
    assert(rem(numbatches, 1) == 0, 'numbatches not integer');

    run_until_threshold = opts.numepochs < 1;
    if(!isfield(opts,"threshold")) opts.threshold = 0.01; endif;
    if(!isfield(opts,"numsampleits")) opts.numsampleits = 1; endif;
    it = 0;
    oldErr = 0; err = inf;
    do
        oldErr = err;
        it++;
        kk = randperm(m);
        err = 0;
        for l = 1 : numbatches
            batch = x(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize), :);
            
            v_begin = batch;
            h_end = h_begin = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + v_begin * rbm.W');
            
            for it = 1:opts.numsampleits
                v_end = sigmrnd(repmat(rbm.b', opts.batchsize, 1) + h_end * rbm.W);
                h_end = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + v_end * rbm.W');
            end

            c1 = h_begin' * v_begin;
            c2 = h_end' * v_end;

            #Calculate the changes to the parameters. Store them in order to compute a momentum term.
            rbm.vW = rbm.momentum * rbm.vW + rbm.alpha * (c1 - c2)     / opts.batchsize;
            rbm.vb = rbm.momentum * rbm.vb + rbm.alpha * sum(v_begin - v_end)' / opts.batchsize;
            rbm.vc = rbm.momentum * rbm.vc + rbm.alpha * sum(h_begin - h_end)' / opts.batchsize;

            rbm.W = rbm.W + rbm.vW;
            rbm.b = rbm.b + rbm.vb;
            rbm.c = rbm.c + rbm.vc;

            err = err + sum(sum((v_begin - v_end) .^ 2)) / opts.batchsize;
        end
        
        err /= numbatches;
        if(run_until_threshold)
            disp(['epoch ' num2str(i) '. Average reconstruction error is: ' num2str(err)]);
        else
            disp(['epoch ' num2str(it) '/' num2str(opts.numepochs)  '. Average reconstruction error is: ' num2str(err)]);
        endif
    until( run_until_threshold && (oldErr - err < opts.threshold) #Condition for running to threshold
                                  ||
          !run_until_threshold && (it >= opts.numepochs)); #Condition for iterating
end
