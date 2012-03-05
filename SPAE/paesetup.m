function pae = paesetup(pae, x, opts)
    for j = 1 : pae.outputmaps   %  activation maps
        pae.a{j} = zeros(size(x{1}) + pae.inputkernel - 1);
        for i = 1 : numel(x)   %  input map
            pae.ik{i}{j} = randn(pae.inputkernel)  * 0.1;
            pae.ok{i}{j} = randn(pae.outputkernel) * 0.1;
        end
        pae.b{j} = randn(1) * 0.01;
    end

    pae.alpha = opts.alpha;

    pae.i = cell(numel(x), 1);
    pae.o = pae.i;

    for i = 1 : numel(pae.o)
        pae.c{i} = randn(1) * 0.01;
    end

    ss = pae.outputkernel;

    pae.edgemask = zeros([opts.batchsize size(x{1},2) size(x{1},3)]);

    pae.edgemask(ss(1) : end - ss(1) + 1, ss(2) : end - ss(2) + 1, ss(3) : end - ss(3) + 1) = 1;
end
