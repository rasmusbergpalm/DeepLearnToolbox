function sae = saesetup(sae, x)
    n = numel(sae.size);

    for u = 1 : n
        sae.ae{u} = nnsetup(struct('size', sae.size(u)), x, x);

        x = zeros(1, sae.size(u));
    end
end
