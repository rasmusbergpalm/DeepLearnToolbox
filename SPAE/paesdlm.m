function pae = paesdlm(pae, opts, m)
    %stochastic diagonal levenberg-marquardt
    
    %first round
    if isfield(pae,'ddok') == 0
        pae = paebbp(pae);
    end

    %recalculate double grads every opts.ddinterval
    if mod(m, opts.ddinterval) == 0  
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
end