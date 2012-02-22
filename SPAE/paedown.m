function pae = paedown(pae)
    pa = pae.a;
    pok = pae.ok;

    for i=1:numel(pae.o)
        z = 0;
        for j=1:numel(pae.a)
            z = z + convn(pa{j}, pok{i}{j}, 'valid');
        end
        pae.o{i} = sigm(z + pae.c{i});
        
    end

end