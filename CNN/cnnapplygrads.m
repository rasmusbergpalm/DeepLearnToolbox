function net = cnnapplygrads(net, opts)
    for l = 2 : numel(net.layers)
        if (strcmp(net.layers{l}.type, 't') || strcmp(net.layers{l}.type, 'c') || strcmp(net.layers{l}.type, 'st'))
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    %net.layers{l}.k{ii}{j} = net.layers{l}.k{ii}{j} - opts.alpha * net.layers{l}.dk{ii}{j};
                    % added momentum for CNN here
                    net.layers{l}.vk{ii}{j} = opts.momentum*net.layers{l}.vk{ii}{j} - opts.alpha * net.layers{l}.dk{ii}{j};
                    net.layers{l}.k{ii}{j} =  net.layers{l}.k{ii}{j} +  net.layers{l}.vk{ii}{j};
                    
                end
                 % added momentum for CNN here
                %net.layers{l}.b{j} = net.layers{l}.b{j} - opts.alpha * net.layers{l}.db{j};
                
                net.layers{l}.vb{j} = opts.momentum*net.layers{l}.vb{j} - opts.alpha * net.layers{l}.db{j};                
                net.layers{l}.b{j} = net.layers{l}.b{j} + net.layers{l}.vb{j}  ;
            end
        end
    end

    net.ffW = net.ffW - opts.alpha * net.dffW;
    net.ffb = net.ffb - opts.alpha * net.dffb;
  
end
