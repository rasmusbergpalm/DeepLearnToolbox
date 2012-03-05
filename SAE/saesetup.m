function sae = saesetup(sae, x)
    for u = 1 : numel(sae.size)
        sae.ae{u} = nnsetup(struct('size', sae.size(u)), x, x);
        x = zeros(1, sae.size(u));
    end
end
