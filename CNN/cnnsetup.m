function net = cnnsetup(net, mapsize, onum)
  
  if (~isfield(net, 'batchsize'))
    net.batchsize = 50;  
  end;
  if (~isfield(net, 'numepochs'))
    net.numepochs = 1;  
  end;  
  if (~isfield(net, 'alpha'))
    net.alpha = 1;  
  end;  
  net.rL = [];
    
  outputmaps = 1;        
  for l = 1 : numel(net.layers)   %  layer
    if strcmp(net.layers{l}.type, 's') % scaling      
      mapsize = ceil(mapsize ./ net.layers{l}.scale);
      for j = 1 : outputmaps
        net.layers{l}.b{j} = 0;
      end    
    elseif strcmp(net.layers{l}.type, 'c') % convolutional
      mapsize = mapsize - net.layers{l}.kernelsize + 1;
      fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize(1) * net.layers{l}.kernelsize(2);
      for j = 1 : net.layers{l}.outputmaps  %  output map
        fan_in = outputmaps * net.layers{l}.kernelsize(1) *  net.layers{l}.kernelsize(2);
        for i = 1 : outputmaps  %  input map
          net.layers{l}.k{i, j} = (rand(net.layers{l}.kernelsize(1), net.layers{l}.kernelsize(2)) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out));
          net.layers{l}.dk{i, j} = zeros(net.layers{l}.kernelsize(1), net.layers{l}.kernelsize(2));          
        end
        net.layers{l}.b{j} = 0;
        net.layers{l}.db{j} = 0;        
      end
      outputmaps = net.layers{l}.outputmaps;        
    end
    net.layers{l}.outputmaps = outputmaps;
    net.layers{l}.mapsize = mapsize;
  end
  
  % 'onum' is the number of labels, that's why it is calculated using size(y, 2). If you have 20 labels so the output of the network will be 20 neurons.
  % 'fvnum' is the number of output neurons at the last layer, the layer just before the output layer.
  % 'ffb' is the biases of the output neurons.
  % 'ffW' is the weights between the last layer and the output neurons. Note that the last layer is fully connected to the output layer, that's why the size of the weights is (onum * fvnum)
  
  fvnum = mapsize(1) * mapsize(2) * outputmaps;
  net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6/(onum + fvnum));
  net.dffW = zeros(onum, fvnum);
  
  net.ffb = zeros(onum, 1);
  net.dffb = zeros(onum, 1);  
end
