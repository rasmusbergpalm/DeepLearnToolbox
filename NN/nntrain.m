function net = nntrain(net, x, y, opts)
    m = size(x,1);
    numbatches = m/opts.batchsize;
    if(rem(numbatches,1)~=0)
        error('numbatches not integer');
    end
    net.rL = [];
    for i=1:opts.numepochs
        kk = randperm(m);
        tic;
        for l=1:numbatches
            batch_x = double(x(kk((l-1)*opts.batchsize+1:l*opts.batchsize),:));
            batch_y = double(y(kk((l-1)*opts.batchsize+1:l*opts.batchsize),:));
            net = nnff(net, batch_x, batch_y);
    %             if(rand() < 1e-3)
    %                 disp 'Performing numerical gradient checking ...';
    %                 nnchecknumgrad(net, x(i,:), y(i,:));
    %                 disp 'No errors found ...';
    %             end
            net = nnbp(net);
            net = nnapplygrads(net);
            net.rL = [net.rL net.L];
        end
        toc;
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
    end

end