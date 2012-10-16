function nn = dbnunfoldtonn(dbn, outputsize)
%DBNUNFOLDTONN Unfolds a DBN to a NN
%   dbnunfoldtonn(dbn, outputsize ) returns the unfolded dbn with a final
%   layer of size outputsize added.

    nn = nnsetup([dbn.sizes outputsize]);
    for i = 1 : numel(dbn.rbm)
        nn.W{i} = dbn.rbm{i}.W;
        nn.b{i} = dbn.rbm{i}.c;
    end
end

