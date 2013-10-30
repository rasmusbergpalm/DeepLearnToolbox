function net = cnnbp(net, y)
  n = numel(net.layers);
  batchsize = size(y, 1); % number of examples in the minibatch    
  curder = (y ./ repmat(net.part, batchsize, 1) + (1 - y) ./ (1 - repmat(net.part, batchsize, 1))) / 2;
  diffmat = net.o - y;
  net.L = 1/2 * sum(diffmat(:).^2) / batchsize;
  net.od = diffmat .* curder .* (net.o .* (1 - net.o));   %  output delta  
  net.dffW = (net.fv * net.od)' / batchsize;
  net.fvd = (net.od * net.ffW)'; %  feature vector delta    
  net.dffb = mean(net.od, 1)';

  %  reshape feature vector deltas into output map style
  mapsize = net.layers{n}.mapsize;
  maplen = mapsize(1) * mapsize(2);
  for i = 1 : net.layers{n}.outputmaps
    net.layers{n}.d{i} = reshape(net.fvd((i-1)*maplen+1 : i*maplen, :), mapsize(1), mapsize(2), batchsize);      
  end

  for l = (n-1) : -1 : 1

    if strcmp(net.layers{l+1}.type, 's')
      s = net.layers{l+1}.scale;
      for i = 1 : net.layers{l}.outputmaps
        targsize = net.layers{l}.mapsize;
        curder = expand(net.layers{l+1}.d{i}, [s(1) s(2) 1]);
        curval = expand(net.layers{l+1}.a{i}, [s(1) s(2) 1]);
        curder(targsize(1)+1:end, :, :) = [];
        curder(:, targsize(2)+1:end, :) = [];
        curval(targsize(1)+1:end, :, :) = [];
        curval(:, targsize(2)+1:end, :) = [];
        maxmat = (net.layers{l}.a{i} == curval);
        net.layers{l}.d{i} = curder .* maxmat;        
      end

    elseif strcmp(net.layers{l+1}.type, 'c')
      for i = 1 : net.layers{l}.outputmaps
        net.layers{l}.d{i} = zeros(net.layers{l}.mapsize(1), net.layers{l}.mapsize(2), batchsize);
      end;
      for j = 1 : net.layers{l+1}.outputmaps
        sigder = net.layers{l+1}.a{j} .* (1 - net.layers{l+1}.a{j}) .* net.layers{l+1}.d{j};
        net.layers{l+1}.db{j} = sum(sigder(:)) / batchsize;
        for i = 1 : net.layers{l}.outputmaps
          net.layers{l+1}.dk{i, j} = convn(flipall(net.layers{l}.a{i}), sigder, 'valid') / batchsize;
          net.layers{l}.d{i} = net.layers{l}.d{i} + convn(sigder, flipall(net.layers{l+1}.k{i, j}), 'full');
        end          
      end;
    end        
  end

  function X = flipall(X)
    for dimind = 1 : ndims(X)
      X = flipdim(X, dimind);
    end
  end
end
