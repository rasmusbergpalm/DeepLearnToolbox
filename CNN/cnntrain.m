function net = cnntrain(net, x, y, opts)
%% CNNTRAIN train CNN
% x
% y

    m = size(x, 3);
    numbatches = m / net.batchsize;
    assert(rem(numbatches, 1) == 0, 'numbatches must be an integer');
    net.rL = []; % running loss
    for i = 1 : net.numepochs
        disp(['epoch ' num2str(i) '/' num2str(net.numepochs)]);
        tic;
        kk = randperm(m);
        for l = 1 : numbatches
            batch_x = x(:, :, kk((l - 1) * net.batchsize + 1 : l * net.batchsize));
            batch_y = y(:,    kk((l - 1) * net.batchsize + 1 : l * net.batchsize));

            net = cnnff(net, batch_x);
            net = cnnbp(net, batch_y);
            net = cnnapplygrads(net, opts);
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        toc;
    end
end