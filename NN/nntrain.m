function net = nntrain(net, x, y, opts)
    m = size(x,1);
    numbatches = m/opts.batchsize;
    if(rem(numbatches,1)~=0)
        error('numbatches not integer');
    end
    net.rL = [];
    n=1;
    for i=1:opts.numepochs
        kk = randperm(m);
        tic;
        for l=1:numbatches
            batch_x = x(kk((l-1)*opts.batchsize+1:l*opts.batchsize),:);
            if(strcmp(class(batch_x),'uint8'))
                batch_x = double(batch_x)/255;
            end
            batch_y = y(kk((l-1)*opts.batchsize+1:l*opts.batchsize),:);
            if(strcmp(class(batch_y),'uint8'))
                batch_y = double(batch_y)/255;
            end
            net = nnff(net, batch_x, batch_y);
            net = nnbp(net);
            
%             disp 'Performing numerical gradient checking ...';
%             nnchecknumgrad(net, x(i,:), y(i,:));
%             disp 'No errors found ...';
            
            net = nnapplygrads(net);
            if(isempty(net.rL))
                net.rL(n) = net.L;
            end
            net.rL(n+1) = 0.99*net.rL(n) + 0.01*net.L;
            n=n+1;
        end
        t=toc;
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mean squared error is ' num2str(net.rL(end))]);
    end

end