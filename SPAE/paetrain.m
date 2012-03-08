function pae = paetrain(pae, x, opts)
    n = pae.inputkernel(1);
    pae.rL = [];
    for m = 1 : opts.rounds
        tic;
        disp([num2str(m) '/' num2str(opts.rounds) ' rounds']);
        i1 = randi(numel(x));
        l  = randi(size(x{i1}{1},1) - opts.batchsize - n + 1);
        x1{1} = double(x{i1}{1}(l : l + opts.batchsize - 1, :, :)) / 255;

        if n == 1   %Auto Encoder
            x2{1} = x1{1};
        else        %Predictive Encoder
            x2{1} = double(x{i1}{1}(l + n : l + n + opts.batchsize - 1, :, :)) / 255;
        end
        %  Add noise to input, for denoising stacked autoenoder
        x1{1} = x1{1} .* (rand(size(x1{1})) > pae.noise);

        pae = paeup(pae, x1);
        pae = paedown(pae);
        pae = paebp(pae, x2);
        pae = paesdlm(pae, opts, m);
%         paenumgradcheck(pae,x1,x2);
        pae = paeapplygrads(pae);

        if m == 1
            pae.rL(1) = pae.L;
        end
        pae.rL(m + 1) = 0.99 * pae.rL(m) + 0.01 * pae.L;
        if pae.sv < 1e-10
            disp('Converged');
            break;
        end
        toc;
    end

end
