function cae = caeup(cae, x)
    cae.i = x;

    %init temp vars for parrallel processing
    pa  = cell(size(cae.a));
    pi  = cae.i;
    pik = cae.ik;
    pb  = cae.b;

    for j = 1 : numel(cae.a)
        z = 0;
        for i = 1 : numel(pi)
            z = z + convn(pi{i}, pik{i}{j}, 'full');
        end
        pa{j} = sigm(z + pb{j});

        %  Max pool.
        if ~isequal(cae.scale, [1 1 1])
            pa{j} = max3d(pa{j}, cae.M);
        end

    end
    cae.a = pa;

end
