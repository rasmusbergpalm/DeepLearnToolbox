function net = dbntrain(net, x, opts)
    n = numel(net.rbm);
    
    net.rbm{1} = rbmtrain(net.rbm{1}, x, opts);
    for i=2:n
        x = rbmup(net.rbm{i-1}, x);
        net.rbm{i} = rbmtrain(net.rbm{i}, x, opts);
    end
    
end