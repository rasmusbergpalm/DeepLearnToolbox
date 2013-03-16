function labels = nnpredict(nn, x)
%% NNPREDICT let net classify given data x
% no learning on this stage
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;
    
    [~, labels] = max(nn.a{end},[],2);
end
