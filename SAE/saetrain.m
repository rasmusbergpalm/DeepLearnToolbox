function sae = saetrain(sae, x, z, opts)
    n = numel(sae.ae);
    
    sae.ae{1} = nntrain(sae.ae{1}, x, z, opts);
    for i=2:n
        t = nnff(sae.ae{i-1}, x, x);
        x = t.a{2};
        t = nnff(sae.ae{i-1}, z, z);
        z = t.a{2};
        sae.ae{i} = nntrain(sae.ae{i}, x, z, opts);
    end
    
end