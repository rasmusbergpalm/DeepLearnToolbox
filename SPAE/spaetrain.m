function spae = spaetrain(spae, x, opts)

    for i = 1 : numel(spae)
%        for u = 1 : i - 1
%            pae = paeup(spae{u}, x);
%            x = pae.a;
%        end
        pae = spae{i};
        n = pae.inputkernel(1);
        pae.rL = [];
        for m = 1 : opts.rounds
            tic;
            disp([num2str(m) '/' num2str(opts.rounds) ' rounds']);
            i1 = randi(numel(x));
            l  = randi(size(x{i1}{1},1) - opts.batchsize - n + 1);
            x1{1} = double(x{i1}{1}(l : l + opts.batchsize - 1, :, :)) / 255;

            if n == 1   %  Reconstructive Auto-Encoder
                x2{1} = x1{1};
            else        %  Predictive Auto-Encoder
                x2{1} = double(x{i1}{1}(l + n : l + n + opts.batchsize - 1, :, :)) / 255;
            end
            %  Denoising element
            x1{1} = x1{1} .* (rand(size(x1{1})) > pae.noise);

            pae = paeup(pae, x1);
            pae = paedown(pae);
            pae = paebp(pae, x2);
            
            if m == 1
                pae = paebbp(pae);
            end

            %  stochastic diagonal levenberg-marquardt stuff
            if mod(m, opts.ddinterval) == 0   %  recalculate double grads every opts.ddinterval
                pae_n = paebbp(pae);

                for ii = 1 : numel(pae.o)
                    pae.ddc{ii} = opts.ddhist * pae.ddc{ii} + (1 - opts.ddhist) * pae_n.ddc{ii};
                end

                for jj = 1 : numel(pae.a)
                    pae.ddb{jj} = opts.ddhist * pae.ddb{jj} + (1 - opts.ddhist) * pae_n.ddb{jj};
                    for ii = 1 : numel(pae.o)
                        pae.ddok{ii}{jj} = opts.ddhist * pae.ddok{ii}{jj} + (1 - opts.ddhist) * pae_n.ddok{ii}{jj};
                        pae.ddik{ii}{jj} = opts.ddhist * pae.ddik{ii}{jj} + (1 - opts.ddhist) * pae_n.ddik{ii}{jj};
                    end
                end

            end

%            paenumgradcheck(pae,x1,x2);
            pae = paeapplygrads(pae);
%            rvc{m} = pae.vc;
%            rvb{m} = pae.vb;
%            rvik{m} = pae.vik;
%            rvok{m} = pae.vok;

            if m == 1
                pae.rL(1) = pae.L;
            end
            pae.rL(m + 1) = 0.99 * pae.rL(m) + 0.01 * pae.L;
%            disp(pae.sv);
            if pae.sv < 1e-10
                disp('Converged');
                break;
            end
%            if mod(m, 100) == 0
%                if pae.rL(m + 1) >= pae.rL(m - 99))
%                    pae.alpha = pae.alpha / 10;
%                else
%                    pae.alpha = 10 * pae.alpha;
%                end
%                pae.alpha
%            end
%            figure(1);
%            imagesc(squeeze(pae.ok{1}{1}(1, :, :))'); drawnow;
%            figure(2);
%            imagesc(squeeze(pae.ik{1}{1}(1, :, :))'); drawnow;
%            figure(1);
%            imshow(squeeze(pae.e{1}(1, :, :))'); drawnow;
            toc;
        end
        spae{i} = pae;

%        hist = {rvc, rvb, rvik, rvok};

    end

%    beep();
end
