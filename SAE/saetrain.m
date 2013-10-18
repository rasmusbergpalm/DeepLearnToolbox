function sae = saetrain(sae, x, opts)
    for i = 1 : numel(sae.ae);
        if(opts.verbosity >= 1)
            disp(['Training AE ' num2str(i) '/' num2str(numel(sae.ae))]);
        end#if
        sae.ae{i} = nntrain(sae.ae{i}, x, x, opts);
        t = nnff(sae.ae{i}, x, x);
        x = t.a{2};
        %remove bias term
        x = x(:,2:end);
    end
end
