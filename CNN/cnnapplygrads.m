function net = cnnapplygrads(net)
    alpha = 0.01;
    for l=2:numel(net.layers)
        if(strcmp(net.layers{l}.type, 'c'))
             for j=1:numel(net.layers{l}.a)
                for ii=1:numel(net.layers{l-1}.a)
                    net.layers{l}.k{ii}{j} = net.layers{l}.k{ii}{j} - alpha*net.layers{l}.dk{ii}{j};
                end
             end
        end
        net.layers{l}.b{j} = net.layers{l}.b{j} - alpha*net.layers{l}.db{j};
    end

    net.ffW = net.ffW - alpha * net.dffW;
    net.ffb = net.ffb - alpha * net.dffb;
end