function rbm = rbmtrain(rbm, x, opts)
    assert(isfloat(x), 'x must be a float');
    m = size(x, 1);
    numbatches = m / opts.batchsize;
    
    assert(rem(numbatches, 1) == 0, 'numbatches not integer');

	#checking and initialising some options
    runUntilThresholdIsReached = opts.numepochs < 1;
    if(!isfield(opts,"threshold")) opts.threshold = 0.01; endif;
    if(!isfield(opts,"gibbsSamplingSteps")) opts.gibbsSamplingSteps = 1; endif;

    iterator = 0;
    oldError = 0; currentError = inf;
    do
        oldError = currentError;
        iterator++;
        kk = randperm(m);
        currentError = 0;
        for l = 1 : numbatches
            batch = x(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize), :);
            
            visibleActivationsAtBegin = batch;
            hiddenActivationsAtEnd = hiddenActivationsAtBegin = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + visibleActivationsAtBegin * rbm.W');
            
            for sampleStep = 1:opts.gibbsSamplingSteps
                visibleActivationsAtEnd = sigmrnd(repmat(rbm.b', opts.batchsize, 1) + hiddenActivationsAtEnd * rbm.W);
                hiddenActivationsAtEnd = sigmrnd(repmat(rbm.c', opts.batchsize, 1) + visibleActivationsAtEnd * rbm.W');
            end#for

            c1 = hiddenActivationsAtBegin' * visibleActivationsAtBegin;
            c2 = hiddenActivationsAtEnd' * visibleActivationsAtEnd;

            #Calculate the changes to the parameters. Store them in order to compute a momentum term.
            rbm.vW = rbm.momentum * rbm.vW + rbm.alpha * (c1 - c2)     / opts.batchsize;
            rbm.vb = rbm.momentum * rbm.vb + rbm.alpha * sum(visibleActivationsAtBegin - visibleActivationsAtEnd)' / opts.batchsize;
            rbm.vc = rbm.momentum * rbm.vc + rbm.alpha * sum(hiddenActivationsAtBegin - hiddenActivationsAtEnd)' / opts.batchsize;

            rbm.W = rbm.W + rbm.vW;
            rbm.b = rbm.b + rbm.vb;
            rbm.c = rbm.c + rbm.vc;

            currentError = currentError + sum(mysumsq(visibleActivationsAtBegin - visibleActivationsAtEnd)) / opts.batchsize;
        end#for
        
        currentError /= numbatches;
        if(opts.verbosity >= 1)
            if(runUntilThresholdIsReached)
                disp(['epoch ' num2str(iterator) '. Average reconstruction error is: ' num2str(currentError)]);
            else
                disp(['epoch ' num2str(iterator) '/' num2str(opts.numepochs)  '. Average reconstruction error is: ' num2str(currentError)]);
            end#if
        end#if
    until( runUntilThresholdIsReached && (oldError - currentError < opts.threshold) #Condition for running to threshold
                                  ||
          !runUntilThresholdIsReached && (iterator >= opts.numepochs)); #Condition for iterating
end
