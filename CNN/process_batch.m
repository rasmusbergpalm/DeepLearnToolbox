%l is the batch number
function process_batch(x, y, kk, global_net, turn, start, numbatches,  pid, numWorkers, opts)
	net.p = 0;
	net.rL = [];
	inited = 0;
	
	net.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
    };
	
	for l = start + 1 : start + numbatches - 3
	    %batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
        %batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

		net = cnnff(net, x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize)));
        net = cnnbp(net, y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize)));
        net = cnnapplygrads(net, opts);
		
		if inited == 0 
		   net = cnncopy(net, global_net);
		   inited = 1;
		end
       
	    if isempty(net.rL)
           net.rL(1) = net.L;
        end
        net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
	
	    %If we cannot update our results keep going to the next batch
		if turn == pid
	       global_net = cnnavg(global_net, net);
		   net = cnncopy(net, global_net);
		   turn = mod((turn + 1), numWorkers)
	    end
	end
end