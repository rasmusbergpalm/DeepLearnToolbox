function net = cnnbp(net)
    
    n = numel(net.layers);
    
    %% backprop deltas
    net.od = -(net.e).*(net.o.*(1-net.o)); %output delta
    net.fvd = (net.ffW'*net.od).*(net.fv.*(1-net.fv)); %feature vector delta
    
    %reshape feature vector deltas into output map style
    fvnum = numel(net.layers{n}.a{1});
    for j=1:numel(net.layers{n}.a)
        net.layers{n}.d{j} = reshape(net.fvd(((j-1)*fvnum+1):j*fvnum), sqrt(fvnum), sqrt(fvnum));
    end
    
    for l = (n-1):-1:1
        if(strcmp(net.layers{l}.type, 'c'))
            for j=1:numel(net.layers{l}.a)
                net.layers{l}.d{j} = net.layers{l}.a{j}.*(1-net.layers{l}.a{j}).*kron(net.layers{l+1}.d{j}, ones(net.layers{l+1}.scale)/net.layers{l+1}.scale^2);
            end
        elseif(strcmp(net.layers{l}.type, 's'))
            for i=1:numel(net.layers{l}.a)
                z = zeros(size(net.layers{l}.a{1}));
                for j=1:numel(net.layers{l+1}.a)
                     z = z + conv2(net.layers{l+1}.d{j}, rot180(net.layers{l+1}.k{i}{j}), 'full');
                end
                net.layers{l}.d{i} = net.layers{l}.a{i}.*(1-net.layers{l}.a{i}).*z; %f(x) = x => f'(x) = 1
            end
        end
    end
    
    %% calc gradients
    for l=2:n
        if(strcmp(net.layers{l}.type, 'c'))
            for j=1:numel(net.layers{l}.a)
                for i=1:numel(net.layers{l-1}.a) 
                    net.layers{l}.dk{i}{j} = rot180(conv2(net.layers{l-1}.a{i}, rot180(net.layers{l}.d{j}), 'valid'));
                end
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:));
            end
        elseif(strcmp(net.layers{l}.type, 's'))
            for j=1:numel(net.layers{l}.a)
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:));
            end
        end
    end
    net.dffW = net.od*(net.fv)';
    net.dffb = net.od;
    
    function x = rot180(x)
        x = fliplrf(flipudf(x));
%         x = rot90(rot90(x));
    end
    
end