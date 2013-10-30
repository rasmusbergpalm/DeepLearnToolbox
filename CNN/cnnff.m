function [net, err] = cnnff(net, x)
  n = numel(net.layers);
  batchsize = size(x, 3); % number of examples in the minibatch
  net.layers{1}.a{1} = x;

  for l = 2 : n   %  for each layer

    if strcmp(net.layers{l}.type, 'c')
      for j = 1 : net.layers{l}.outputmaps   %  for each output map
        %  create temp output map
        mapsize = net.layers{l-1}.mapsize;
        z = zeros([mapsize batchsize] - [net.layers{l}.kernelsize(1) - 1 net.layers{l}.kernelsize(2) - 1 0]);
        for i = 1 : net.layers{l-1}.outputmaps   %  for each input map
          %  convolve with corresponding kernel and add to temp output map
          z = z + convn(net.layers{l-1}.a{i}, net.layers{l}.k{i, j}, 'valid');              
        end            
        net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});          
      end        

    elseif strcmp(net.layers{l}.type, 's')
      % downsample
      s = net.layers{l}.scale;       
      b = strel('rectangle', [s(1) s(2)]);
      for j = 1 : net.layers{l-1}.outputmaps
        fi = ceil((s+1)/2);
        a = zeros(fi(1)+s(1)*(net.layers{l}.mapsize(1)-1), fi(2)+s(2)*(net.layers{l}.mapsize(2)-1), batchsize);
        a(1:net.layers{l-1}.mapsize(1), 1:net.layers{l-1}.mapsize(2), :) = net.layers{l-1}.a{j};
        z = imdilate(a, b);
        net.layers{l}.a{j} = z(fi(1):s(1):end, fi(2):s(2):end, :);          
      end
    end
  end

  %  concatenate all end layer feature maps into vector
  mapsize = net.layers{n}.mapsize;
  maplen = mapsize(1) * mapsize(2);    
  mapnum = net.layers{n}.outputmaps;
  net.fv = zeros(maplen*mapnum, batchsize);
  for j = 1 : mapnum      
    net.fv((j-1)*maplen+1 : j*maplen, :) = reshape(net.layers{n}.a{j}, maplen, batchsize);
  end

  %  feedforward into output perceptrons
  net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, batchsize))';    
end
