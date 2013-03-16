function net = cnnapplygrads(net, opts)
%% CNNAPLYGRADS modify new weights from gradients
% net.aplha is learning rate

    for l = 2 : numel(net.layers)
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    net.layers{l}.k{ii}{j} = net.layers{l}.k{ii}{j} - net.alpha * net.layers{l}.dk{ii}{j};
                end
                net.layers{l}.b{j} = net.layers{l}.b{j} - net.alpha * net.layers{l}.db{j};
            end
        end
    end

    net.ffW = net.ffW - net.alpha * net.dffW;
    net.ffb = net.ffb - net.alpha * net.dffb;
end
