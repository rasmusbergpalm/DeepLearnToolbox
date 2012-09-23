function cae = caeapplygrads(cae)
    cae.sv = 0;
    for j = 1 : numel(cae.a)
        for i = 1 : numel(cae.i)
%             cae.vik{i}{j} = cae.momentum * cae.vik{i}{j} + cae.alpha ./ (cae.sigma + cae.ddik{i}{j}) .* cae.dik{i}{j};
%             cae.vok{i}{j} = cae.momentum * cae.vok{i}{j} + cae.alpha ./ (cae.sigma + cae.ddok{i}{j}) .* cae.dok{i}{j};
            cae.vik{i}{j} = cae.alpha * cae.dik{i}{j};
            cae.vok{i}{j} = cae.alpha * cae.dok{i}{j};
            cae.sv = cae.sv + sum(cae.vik{i}{j}(:) .^ 2);
            cae.sv = cae.sv + sum(cae.vok{i}{j}(:) .^ 2);

            cae.ik{i}{j} = cae.ik{i}{j} - cae.vik{i}{j};
            cae.ok{i}{j} = cae.ok{i}{j} - cae.vok{i}{j};
        end
%         cae.vb{j} = cae.momentum * cae.vb{j} + cae.alpha / (cae.sigma + cae.ddb{j}) * cae.db{j};
        cae.vb{j} = cae.alpha * cae.db{j};
        cae.sv = cae.sv + sum(cae.vb{j} .^ 2);

        cae.b{j} = cae.b{j} - cae.vb{j};
    end

    for i = 1 : numel(cae.o)
%         cae.vc{i} = cae.momentum * cae.vc{i} + cae.alpha / (cae.sigma + cae.ddc{i}) * cae.dc{i};
        cae.vc{i} = cae.alpha * cae.dc{i};
        cae.sv = cae.sv + sum(cae.vc{i} .^ 2);

        cae.c{i} = cae.c{i} - cae.vc{i};
    end
end
