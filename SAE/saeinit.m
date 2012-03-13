function sae = saeinit(layers)
    sae.size = layers;
    sae.n    = length(layers);

    n = sae.n;

    for u = 2 : n - 1
        sae.ae{u} = aeinit([layers(u - 1) layers(u) layers(u - 1)]);
    end
end
