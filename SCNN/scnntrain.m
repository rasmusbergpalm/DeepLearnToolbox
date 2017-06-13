function net = scnntrain(net, x, y, opts)
    m = numel(x);
    numbatches = m / opts.batchsize;
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    net.rL = [];
    wb = waitbar(0,'Training...(Sparse)');
    sum_count = opts.numepochs * numbatches;
    t_index = 1;
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);
        for l = 1 : numbatches
            
            waitbar(t_index/sum_count,wb,...
                sprintf('Training...Epoch:%d of %d  BatchIndex%d of %d',i,opts.numepochs,l,numbatches));
            
            batch_x = x(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = scnnff(net, batch_x);
            net = scnnbp(net, batch_y);
            net = scnnapplygrads(net, opts);
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
            t_index = t_index + 1;
        end
        toc;
    end
    
end
