function spae = spaesetup(spae, x, opts)
    x = x{1};
    for l = 1 : numel(spae)
        pae = spae{l};
        ll= [opts.batchsize size(x{1}, 2) size(x{1}, 3)] + pae.inputkernel - 1;
        X = zeros(ll);
        pae.M = nbmap(X, pae.scale);
        bounds = pae.outputmaps * prod(pae.inputkernel) + numel(x) * prod(pae.outputkernel);
        for j = 1 : pae.outputmaps   %  activation maps
            pae.a{j} = zeros(size(x{1}) + pae.inputkernel - 1);
            for i = 1 : numel(x)    %  input map
                pae.ik{i}{j}  = (rand(pae.inputkernel)  - 0.5) * 2 * sqrt(6 / bounds);
                pae.ok{i}{j}  = (rand(pae.outputkernel) - 0.5) * 2 * sqrt(6 / bounds);
                pae.vik{i}{j} = zeros(size(pae.ik{i}{j}));
                pae.vok{i}{j} = zeros(size(pae.ok{i}{j}));
            end
            pae.b{j} = 0;
            pae.vb{j} = zeros(size(pae.b{j}));
        end

        pae.alpha = opts.alpha;

        pae.i = cell(numel(x), 1);
        pae.o = pae.i;

        for i = 1 : numel(pae.o)
            pae.c{i}  = 0;
            pae.vc{i} = zeros(size(pae.c{i}));
        end

        ss = pae.outputkernel;

        pae.edgemask = zeros([opts.batchsize size(x{1}, 2) size(x{1}, 3)]);

        pae.edgemask(ss(1) : end - ss(1) + 1, ...
                     ss(2) : end - ss(2) + 1, ...
                     ss(3) : end - ss(3) + 1) = 1;

        spae{l} = pae;
    end
end
