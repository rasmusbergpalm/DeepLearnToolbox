function net = cnntrain(net, x, y, opts, varargin)

        
    if length(size(x))==3 % gray scale image
         m = size(x, 3);
    else
         m = size(x, 4);  % 3 channel color images
    end
    
    
    numbatches = m / opts.batchsize;
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    net.rL = [];
    net.val_L=[];% Add a validation recognition rate
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);
        for l = 1 : numbatches
          if length(size(x))==3 % gray scale image
             batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
          else  % 3 channel color images 
             batch_x = x(:, :, :,kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
          end
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = cnnff(net, batch_x);
            net = cnnbp(net, batch_y);
            net = cnnapplygrads(net, opts);
            
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        
        if ~isempty(varargin) % An eary stopping scheme added
            [er, bad]= cnntest(net, x_val, y_val);
            net.val_L(end+1)=1-er;
            if (i>2 && net.val_L(end)<net.val_L(end-1))
               fprintf('Early stop occur, epoch is: %d, val rate: %f',i,net.val_L(end-1));
               break;
            end        
        end
    fprintf('1 epoch uses %d second\n',toc);
    end
    
end
