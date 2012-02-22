function pae = paebbp(pae)
    
    %% backprop deltas
    for i=1:numel(pae.o)
        %output delta delta
        pae.odd{i} = (pae.o{i}.*(1-pae.o{i}).*pae.edgemask).^2;
        %delta delta c
        pae.ddc{i} = sum(pae.odd{i}(:))/size(pae.odd{i},1);
    end
    
    for j=1:numel(pae.a) %calc activation delta deltas
        z = 0;
        for i=1:numel(pae.o)
             z = z + convn(pae.odd{i}, flipall(pae.ok{i}{j}.^2), 'full');
        end
        pae.add{j} = (pae.a{j}.*(1-pae.a{j})).^2.*z;
    end
    
    %% calc params delta deltas
    ns = size(pae.odd{1},1);
    for j=1:numel(pae.a)
        pae.ddb{j} = sum(pae.add{j}(:))/ns;
        for i=1:numel(pae.o)
            pae.ddok{i}{j} = convn(flipall(pae.a{j}.^2), pae.odd{i}, 'valid')/ns;
            pae.ddik{i}{j} = convn(pae.add{j}, flipall(pae.i{i}.^2), 'valid')/ns;
        end
    end
    
end