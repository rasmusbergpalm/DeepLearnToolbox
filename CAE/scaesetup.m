function scae = scaesetup(cae, x, opts)
    x = x{1};
    for l = 1 : numel(cae)
        cae = cae{l};
        ll= [opts.batchsize size(x{1}, 2) size(x{1}, 3)] + cae.inputkernel - 1;
        X = zeros(ll);
        cae.M = nbmap(X, cae.scale);
        bounds = cae.outputmaps * prod(cae.inputkernel) + numel(x) * prod(cae.outputkernel);
        for j = 1 : cae.outputmaps   %  activation maps
            cae.a{j} = zeros(size(x{1}) + cae.inputkernel - 1);
            for i = 1 : numel(x)    %  input map
                cae.ik{i}{j}  = (rand(cae.inputkernel)  - 0.5) * 2 * sqrt(6 / bounds);
                cae.ok{i}{j}  = (rand(cae.outputkernel) - 0.5) * 2 * sqrt(6 / bounds);
                cae.vik{i}{j} = zeros(size(cae.ik{i}{j}));
                cae.vok{i}{j} = zeros(size(cae.ok{i}{j}));
            end
            cae.b{j} = 0;
            cae.vb{j} = zeros(size(cae.b{j}));
        end

        cae.alpha = opts.alpha;

        cae.i = cell(numel(x), 1);
        cae.o = cae.i;

        for i = 1 : numel(cae.o)
            cae.c{i}  = 0;
            cae.vc{i} = zeros(size(cae.c{i}));
        end

        ss = cae.outputkernel;

        cae.edgemask = zeros([opts.batchsize size(x{1}, 2) size(x{1}, 3)]);

        cae.edgemask(ss(1) : end - ss(1) + 1, ...
                     ss(2) : end - ss(2) + 1, ...
                     ss(3) : end - ss(3) + 1) = 1;

        scae{l} = cae;
    end
    
    function B = nbmap(X,n)
        assert(numel(n)==3,'n should have 3 elements (x,y,z) scaling.');
        X = reshape(1:numel(X),size(X,1),size(X,2),size(X,3));
        B = zeros(size(X,1)/n(1),prod(n),size(X,2)*size(X,3)/prod(n(2:3)));
        u=1;
        p=1;
        for m=1:size(X,1)
            B(u,(p-1)*prod(n(2:3))+1:p*prod(n(2:3)),:) = im2col(squeeze(X(m,:,:)),n(2:3),'distinct');
            p=p+1;
            if(mod(m,n(1))==0)
                u=u+1;
                p=1;
            end
        end

    end
end
