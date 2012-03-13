function ae = aetrain(ae, x, opts)
    n = ae.n;

    printf('Training AE');

    ae = nntrain(ae, x, x, opts);

    printf('\n')
end
