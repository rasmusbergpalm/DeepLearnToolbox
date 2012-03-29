function nn = nntrain(nn, x, y, opts, x_test, y_test)
    m = size(x, 1);

    opt.debug    = 0;
    opt.optimize = 'speed';
    opt.verbose  = 1;

    if strcmp(opt.optimize, 'speed')
        if strcmp(class(x), 'uint8')
            x = double(x) / 255;
        end

        if strcmp(class(y), 'uint8')
            y = double(y) / 255;
        end
    end

    batchsize = opts.batchsize;
    numepochs = opts.numepochs;
%    numepochs = 300;

    numbatches = m / batchsize;

    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end

    if 1   %%  stochastic gradient descent
        nn.rL = [];
        n = 1;
        for i = 1 : numepochs
            tic;

            kk = randperm(m);
            for l = 1 : numbatches
                batch_x = x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
                batch_y = y(kk((l - 1) * batchsize + 1 : l * batchsize), :);

                if strcmp(opt.optimize, 'memory')
                    if strcmp(class(x), 'uint8')
                        batch_x = double(batch_x) / 255;
                    end

                    if strcmp(class(y), 'uint8')
                        batch_y = double(batch_y) / 255;
                    end
                end

                if 0
                    nn = nnff(nn, batch_x, batch_y);

                    if rand() < opt.debug
                        printf('Performing numerical gradient checking ...\n');
                        nnchecknumgrad(nn, x(i, :), y(i, :));
                        printf('No errors found ...\n');
                    end

                    nn = nnbp(nn);

                    nn = nnapplygrads(nn);

                    if n == 1
                        nn.rL(n) = nn.L;
                    else
                        nn.rL(n) = 0.99 * nn.rL(n - 1) + 0.01 * nn.L;
                    end

                    n = n + 1;

                    if opt.verbose & l == numbatches
                        t = toc;
                        fprintf('Epoch %2d/%2d. Took %f seconds. Mean squared error is %f.\n', i, numepochs, t, nn.rL(end));

%                        if i == 10 * floor(i / 10) & i < numepochs
                        if exist('x_test') & exist('y_test') & i == 10 * floor(i / 10)
                            [er, bad] = nntest(nn, x_test, y_test);

                            printf(' Recognition error: %5.2f%%\n', 100 * er)
                        end
                    end
                else
                    J = @(X) nnJ(nn, X, batch_x, batch_y);

                    X = nnunpackWb(nn);

                    [X JX] = nngraddescent(J, X, nn.alpha, 1);
%                    options = optimset('MaxIter', 50);
%%                    options = optimset('MaxIter', numepochs);
%                    [X JX] = fmincg(J, X, options);
                    X';
                    JX;

                    nn = nnrepackWb(nn, X);

                    if opt.verbose & l == numbatches
                        t = toc;
                        fprintf('Epoch %2d/%2d. Took %6.2f seconds. J = %f.\n', i, numepochs, t, JX);

%                        if i == 10 * floor(i / 10) & i < numepochs
                        if exist('x_test') & exist('y_test') & i == 10 * floor(i / 10)
                            [er, bad] = nntest(nn, x_test, y_test);

                            printf(' Recognition error: %5.2f%%\n', 100 * er)
                        end
                    end
                end
            end
        end
    elseif 1   %%  gradient descent
        N = 1;

        for i = 1 : numepochs / N
            tic;

            J = @(X) nnJ(nn, X, x, y);

            X = nnunpackWb(nn);

            [X JX] = nngraddescent(J, X, nn.alpha, N);

            nn = nnrepackWb(nn, X);

            t = toc;
            fprintf('Epoch %2d/%2d. Took %f seconds. J = %f.\n', i * N, numepochs, t, JX);

            if exist('x_test') & exist('y_test') & i * N == 10 * floor(i * N / 10)
                [er, bad] = nntest(nn, x_test, y_test);

                printf(' Recognition error: %5.2f%%\n', 100 * er)
            end
        end
    else   %%  use all the data at once
        tic;

        x = x(1 : 200, :);
        y = y(1 : 200, :);

        J = @(X) nnJ(nn, X, x, y);

        X = nnunpackWb(nn);

        if 0
            [X JX] = nngraddescent(J, X, nn.alpha, numepochs);
            X';
            fX;
        else
            options = optimset('MaxIter', 50);
%            options = optimset('MaxIter', numepochs);
            [X JX] = fmincg(J, X, options);
            X';
            fX;
        end

        nn = nnrepackWb(nn, X);

        if opt.verbose & l == numbatches
            t = toc;
            fprintf('Epoch %2d/%2d. Took %f seconds. J = %f.\n', i, numepochs, t, JX);

            [er, bad] = nntest(nn, x_test, y_test);

            fprintf(' Recognition error: %5.2f%%\n', 100 * er)
        end
    end
end
