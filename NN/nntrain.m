function nn = nntrain(nn, x, y, opts)
    assert(isfloat(x), 'x must be a float');
    m = size(x, 1);
    
    batchsize = opts.batchsize;
    numepochs = opts.numepochs;

    numbatches = m / batchsize;

    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end

    nn.rL = [];
    n = 1;
    for i = 1 : numepochs
        tic;

        kk = randperm(m);
        for l = 1 : numbatches
            batch_x = x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
            batch_y = y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
            
            nn = nnff(nn, batch_x, batch_y);
            nn = nnbp(nn);
            
%             Enable to verify numerical correcness of algorithm
%             disp 'Performing numerical gradient checking ...';
%             nnchecknumgrad(nn, batch_x, batch_y);
%             disp 'No errors found ...';
            
            nn = nnapplygrads(nn);

            if n == 1
                nn.rL(n) = nn.L;
            end

            nn.rL(n + 1) = 0.99 * nn.rL(n) + 0.01 * nn.L;
            n = n + 1;
        end

        t = toc;
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mean squared error is ' num2str(nn.rL(end))]);
    end
end
