function nn = nntrain(nn, x, y, opts)
    m = size(x, 1);

    opt.optimize = 'memory';

    if opt.optimize == 'speed'
      if strcmp(class(x), 'uint8')
        x = double(x) / 255;
      end

      if strcmp(class(y), 'uint8')
        y = double(y) / 255;
      end
    end

    batchsize = opts.batchsize;
    numepochs = opts.numepochs

    numbatches = m / batchsize;

    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end

    nn.rL = zeros(1, numepochs * numbatches);
    n = 1;
    for i = 1 : numepochs
        tic;

        kk = randperm(m);
        for l = 1 : numbatches
            batch_x = x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
            batch_y = y(kk((l - 1) * batchsize + 1 : l * batchsize), :);

            if opt.optimize == 'memory'
              if strcmp(class(x), 'uint8')
                batch_x = double(batch_x) / 255;
              end

              if strcmp(class(y), 'uint8')
                batch_y = double(batch_y) / 255;
              end
            end

            nn = nnff(nn, batch_x, batch_y);

            if rand() < 1e-3
              disp 'Performing numerical gradient checking ...';
              nnchecknumgrad(nn, x(i, :), y(i, :));
              disp 'No errors found ...';
            end

            nn = nnbp(nn);
            nn = nnapplygrads(nn);

            if n == 1
                nn.rL(n) = nn.L;
            end

            nn.rL(n + 1) = 0.99 * nn.rL(n) + 0.01 * nn.L;
            n = n + 1;
        end

        t = toc;
        printf('epoch %d/%d. Took %f seconds. Mean squared error is %f.', i, opts.numepochs, t, nn.rL(i));
end
