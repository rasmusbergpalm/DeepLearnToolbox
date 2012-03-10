function sae = saetrain(sae, x, opts)
    n = numel(sae.ae);

    for i = 1 : n
        printf('Training AE %d / %d.', i, n);

        sae.ae{i} = nntrain(sae.ae{i}, x, x, opts);

        t = nnff(sae.ae{i}, x, x);
        x = t.a{2};
    end
end
