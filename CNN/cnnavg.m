function avgnet = cnnavg(avgnet, net)
    for l = 2 : numel(net.layers)
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    avgnet.layers{l}.k{ii}{j} = (avgnet.layers{l}.k{ii}{j} + net.layers{l}.k{ii}{j})/2;
                end
                avgnet.layers{l}.b{j} = avgnet.layers{l}.b{j} + net.layers{l}.b{j};
            end
        end
    end

    avgnet.ffW = (avgnet.ffW + net.ffW)/2;
    avgnet.ffb = (avgnet.ffb + net.ffb)/2 ;
end