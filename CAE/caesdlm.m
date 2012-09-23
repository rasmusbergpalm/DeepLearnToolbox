function cae = caesdlm(cae, opts, m)
    %stochastic diagonal levenberg-marquardt
    
    %first round
    if isfield(cae,'ddok') == 0
        cae = caebbp(cae);
    end

    %recalculate double grads every opts.ddinterval
    if mod(m, opts.ddinterval) == 0  
        cae_n = caebbp(cae);

        for ii = 1 : numel(cae.o)
            cae.ddc{ii} = opts.ddhist * cae.ddc{ii} + (1 - opts.ddhist) * cae_n.ddc{ii};
        end

        for jj = 1 : numel(cae.a)
            cae.ddb{jj} = opts.ddhist * cae.ddb{jj} + (1 - opts.ddhist) * cae_n.ddb{jj};
            for ii = 1 : numel(cae.o)
                cae.ddok{ii}{jj} = opts.ddhist * cae.ddok{ii}{jj} + (1 - opts.ddhist) * cae_n.ddok{ii}{jj};
                cae.ddik{ii}{jj} = opts.ddhist * cae.ddik{ii}{jj} + (1 - opts.ddhist) * cae_n.ddik{ii}{jj};
            end
        end

    end
end