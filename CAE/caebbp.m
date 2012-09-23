function cae = caebbp(cae)

    %%  backprop deltas
    for i = 1 : numel(cae.o)
        %  output delta delta
        cae.odd{i} = (cae.o{i} .* (1 - cae.o{i}) .* cae.edgemask) .^ 2;
        %  delta delta c
        cae.ddc{i} = sum(cae.odd{i}(:)) / size(cae.odd{i}, 1);
    end

    for j = 1 : numel(cae.a)   %  calc activation delta deltas
        z = 0;
        for i = 1 : numel(cae.o)
             z = z + convn(cae.odd{i}, flipall(cae.ok{i}{j} .^ 2), 'full');
        end
        cae.add{j} = (cae.a{j} .* (1 - cae.a{j})) .^ 2 .* z;
    end

    %%  calc params delta deltas
    ns = size(cae.odd{1}, 1);
    for j = 1 : numel(cae.a)
        cae.ddb{j} = sum(cae.add{j}(:)) / ns;
        for i = 1 : numel(cae.o)
            cae.ddok{i}{j} = convn(flipall(cae.a{j} .^ 2), cae.odd{i}, 'valid') / ns;
            cae.ddik{i}{j} = convn(cae.add{j}, flipall(cae.i{i} .^ 2), 'valid') / ns;
        end
    end

end
