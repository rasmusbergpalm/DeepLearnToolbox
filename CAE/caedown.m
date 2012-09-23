function cae = caedown(cae)
    pa  = cae.a;
    pok = cae.ok;

    for i = 1 : numel(cae.o)
        z = 0;
        for j = 1 : numel(cae.a)
            z = z + convn(pa{j}, pok{i}{j}, 'valid');
        end
        cae.o{i} = sigm(z + cae.c{i});

    end
end
