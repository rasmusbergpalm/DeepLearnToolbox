function pae = paebp(pae, y)
    
    %% backprop deltas
    pae.L = 0;
    for i=1:numel(pae.o)
        %error
        pae.e{i} = (pae.o{i} - y{i}).*pae.edgemask;
        %loss function
        pae.L = pae.L + 1/2*sum(pae.e{i}(:).^2)/size(pae.e{i},1);
        %output delta
        pae.od{i} = (pae.e{i}).*(pae.o{i}.*(1-pae.o{i}));
        
        pae.dc{i} = sum(pae.od{i}(:))/size(pae.e{i},1);
    end
    
    for j=1:numel(pae.a) %calc activation deltas
        z = 0;
        for i=1:numel(pae.o)
             z = z + convn(pae.od{i}, flipall(pae.ok{i}{j}), 'full');
        end
        pae.ad{j} = pae.a{j}.*(1-pae.a{j}).*z;
    end
    
    %% calc gradients
    ns = size(pae.e{1},1);
    for j=1:numel(pae.a)
        pae.db{j} = sum(pae.ad{j}(:))/ns;
        for i=1:numel(pae.o) 
            pae.dok{i}{j} = convn(flipall(pae.a{j}), pae.od{i}, 'valid')/ns;
            pae.dik{i}{j} = convn(pae.ad{j}, flipall(pae.i{i}), 'valid')/ns;
        end
    end
    
end