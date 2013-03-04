function labels = nnpredict(nn, x)
    if nn.normalize_input==1;
       x = (x-repmat(nn.normalizeMean,size(x,1),1))./repmat(nn.normalizeStd,size(x,1),1);
    end
    
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;
    
    [~, i] = max(nn.a{end},[],2);
    labels = i;
end
