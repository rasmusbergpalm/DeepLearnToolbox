function net = cnnapplygrads(net)
  for l = 2 : numel(net.layers)
    if strcmp(net.layers{l}.type, 'c')
      for j = 1 : net.layers{l}.outputmaps
        for i = 1 : net.layers{l-1}.outputmaps
          net.layers{l}.k{i, j} = net.layers{l}.k{i, j} - net.alpha * net.layers{l}.dk{i, j};
        end
        net.layers{l}.b{j} = net.layers{l}.b{j} - net.alpha * net.layers{l}.db{j};
      end      
    end
  end

  net.ffW = net.ffW - net.alpha * net.dffW;
  net.ffb = net.ffb - net.alpha * net.dffb;
end
