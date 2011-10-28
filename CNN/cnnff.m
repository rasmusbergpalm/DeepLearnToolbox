function net = cnnff(net, x, y)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l=2:n %for each layer
        if(strcmp(net.layers{l}.type, 'c'))
            %!!below can probably be handled by insane matrix operations
            for j=1:net.layers{l}.outputmaps %for each output map
                %create temp output map
                z = zeros(size(net.layers{l-1}.a{1}) - net.layers{l}.kernelsize + 1);
                for i=1:inputmaps %for each input map
                    %convolve with corresponding kernel and add to temp output map
                    z = z + conv2(net.layers{l-1}.a{i}, net.layers{l}.k{i}{j}, 'valid');
                end
                %add bias, pass through nonlinearity
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});
            end
            %set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;
        elseif(strcmp(net.layers{l}.type, 's'))
            %downsample
            for j=1:inputmaps
                z = conv2(net.layers{l-1}.a{j}, ones(net.layers{l}.scale)/(net.layers{l}.scale^2), 'valid'); %!! replace with variable
                net.layers{l}.a{j} = sigm(z(1:net.layers{l}.scale:end,1:net.layers{l}.scale:end)+net.layers{l}.b{j});
            end
        end
    end
    %concatenate all end layer feature maps into vector
    net.fv = [];
    for j=1:numel(net.layers{n}.a)
        net.fv = [net.fv; net.layers{n}.a{j}(:)]; %!! slow
    end
    %feedforward into output perceptrons
    net.o = sigm(net.ffW*net.fv+net.ffb);
    %error
    net.e = y-net.o;
    %loss function
    net.L = 1/2*sum(net.e.^2);
    
end