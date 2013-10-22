
function net = cnntrain(net, x, y, opts)
    m = size(x, 3);
    numbatches = m / opts.batchsize;
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end

    net.rL = [];
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);
        %how many processes?
        numWorkers = 4
		pids = 0:numWorkers-1;
		starts = pids * numbatches / numWorkers
	
		%process starts
		turn = 0;

        pararrayfun(numWorkers,
                    @(starts, pids)process_batch(x, y, kk, net, turn, starts, (numbatches/numWorkers),  pids, numWorkers, opts),
                    starts,
					pids,
					"ErrorHandler" , @eh);
        toc;
    end
end
