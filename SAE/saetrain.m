function sae = saetrain(sae, x, opts)
    n = sae.n;

    for i = 2 : n - 1
        printf('Training AE %d / %d.\n', i - 1, n - 2);

        sae.ae{i} = aetrain(sae.ae{i}, x, opts);

        printf('\n')

%        t = nnff(sae.ae{i}, x, x);
%        x = t.a{2};

        x = aeeval(sae.ae{i}, x);
    end

    printf('\n')
end
