function pae = paeup(pae, x)
    pae.i = x;

    %init temp vars for parrallel processing
    pa  = cell(size(pae.a));
    pi  = pae.i;
    pik = pae.ik;
    pb  = pae.b;

    for j = 1 : numel(pae.a)
        z = 0;
        for i = 1 : numel(pi)
            z = z + convn(pi{i}, pik{i}{j}, 'full');
        end
        pa{j} = sigm(z + pb{j});

        %  Max pool.
        if ~isequal(pae.scale, [1 1 1])
            pa{j} = max3d(pa{j}, pae.M);
        end

    end
    pae.a = pa;

end
