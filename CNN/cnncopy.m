function cpnet = cnncopy(cpnet, net)



    for l = 2 : numel(net.layers)
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    cpnet.layers{l}.k{ii}{j} = net.layers{l}.k{ii}{j};
                end
                cpnet.layers{l}.b{j} = net.layers{l}.b{j};
            end
        end
    end

    cpnet.ffW = net.ffW;
    cpnet.ffb = net.ffb;
end