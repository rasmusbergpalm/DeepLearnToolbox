function cae = caebp(cae, y)

    %%  backprop deltas
    cae.L = 0;
    for i = 1 : numel(cae.o)
        %  error
        cae.e{i} = (cae.o{i} - y{i}) .* cae.edgemask;
        %  loss function
        cae.L = cae.L + 1/2 * sum(cae.e{i}(:) .^2 ) / size(cae.e{i}, 1);
        %  output delta
        cae.od{i} = cae.e{i} .* (cae.o{i} .* (1 - cae.o{i}));

        cae.dc{i} = sum(cae.od{i}(:)) / size(cae.e{i}, 1);
    end

    for j = 1 : numel(cae.a)   %  calc activation deltas
        z = 0;
        for i = 1 : numel(cae.o)
             z = z + convn(cae.od{i}, flipall(cae.ok{i}{j}), 'full');
        end
        cae.ad{j} = cae.a{j} .* (1 - cae.a{j}) .* z;
    end

    %%  calc gradients
    ns = size(cae.e{1}, 1);
    for j = 1 : numel(cae.a)
        cae.db{j} = sum(cae.ad{j}(:)) / ns;
        for i = 1 : numel(cae.o)
            cae.dok{i}{j} = convn(flipall(cae.a{j}), cae.od{i}, 'valid') / ns;
            cae.dik{i}{j} = convn(cae.ad{j}, flipall(cae.i{i}), 'valid') / ns;
        end
    end

end
