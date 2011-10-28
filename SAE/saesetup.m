function sae = saesetup(sae, x)
    n = size(x, 2);
    sae.size = [n, sae.size];
    
    for u=1:numel(sae.size)-1
        sae.ae{u}.alpha = 1;
        sae.ae{u}.lambda = 1e-5;
        sae.ae{u}.size = [sae.size(u) sae.size(u+1) sae.size(u)];
        sae.ae{u}.W{1} = randn(sae.size(u+1), sae.size(u))*0.01;
        sae.ae{u}.W{2} = randn(sae.size(u), sae.size(u+1))*0.01;
        sae.ae{u}.b{1} = zeros(sae.size(u+1), 1);
        sae.ae{u}.b{2} = zeros(sae.size(u), 1);
    end
end