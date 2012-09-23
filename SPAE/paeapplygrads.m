function pae = paeapplygrads(pae)
    pae.sv = 0;
    for j = 1 : numel(pae.a)
        for i = 1 : numel(pae.i)
%             pae.vik{i}{j} = pae.momentum * pae.vik{i}{j} + pae.alpha ./ (pae.sigma + pae.ddik{i}{j}) .* pae.dik{i}{j};
%             pae.vok{i}{j} = pae.momentum * pae.vok{i}{j} + pae.alpha ./ (pae.sigma + pae.ddok{i}{j}) .* pae.dok{i}{j};
            pae.vik{i}{j} = pae.alpha * pae.dik{i}{j};
            pae.vok{i}{j} = pae.alpha * pae.dok{i}{j};
            pae.sv = pae.sv + sum(pae.vik{i}{j}(:) .^ 2);
            pae.sv = pae.sv + sum(pae.vok{i}{j}(:) .^ 2);

            pae.ik{i}{j} = pae.ik{i}{j} - pae.vik{i}{j};
            pae.ok{i}{j} = pae.ok{i}{j} - pae.vok{i}{j};
        end
%         pae.vb{j} = pae.momentum * pae.vb{j} + pae.alpha / (pae.sigma + pae.ddb{j}) * pae.db{j};
        pae.vb{j} = pae.alpha * pae.db{j};
        pae.sv = pae.sv + sum(pae.vb{j} .^ 2);

        pae.b{j} = pae.b{j} - pae.vb{j};
    end

    for i = 1 : numel(pae.o)
%         pae.vc{i} = pae.momentum * pae.vc{i} + pae.alpha / (pae.sigma + pae.ddc{i}) * pae.dc{i};
        pae.vc{i} = pae.alpha * pae.dc{i};
        pae.sv = pae.sv + sum(pae.vc{i} .^ 2);

        pae.c{i} = pae.c{i} - pae.vc{i};
    end
end
