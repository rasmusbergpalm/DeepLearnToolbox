function net = cnnsetup(net,x,y)
    inputmaps = 1;
    mapsize = size(squeeze(x(1,:,:)));
    
    for l=1:numel(net.layers) %layer
        if(strcmp(net.layers{l}.type, 's'))
            mapsize = floor(mapsize/net.layers{l}.scale);
            for j=1:inputmaps
                net.layers{l}.b{j} = randn(1)/10;
            end
        end
        if(strcmp(net.layers{l}.type, 'c'))
            mapsize = mapsize - net.layers{l}.kernelsize + 1;
            for j=1:net.layers{l}.outputmaps %output map
                for i=1:inputmaps %input map
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize)-0.5)*2;
                end
                net.layers{l}.b{j} = randn(1)/10;
            end
            inputmaps = net.layers{l}.outputmaps;
        end
    end
    fvnum = prod(mapsize)*inputmaps;
    onum = numel(y(1,:));
    
    net.ffb = zeros(onum, 1);
    net.ffW = randn(onum, fvnum)*0.01;
end