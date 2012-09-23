function nn = dbnunfoldtonn(dbn)
%DBNUNFOLDTONN Unfolds a DBN to a NN
%   Takes a DBN structure, traverses all layers and assigns upwards weights
%   and biases to an equally sized NN structure which it returns

    nn = nnsetup(dbn.sizes);
    for i = 1 : numel(dbn.rbm)
        nn.W{i} = dbn.rbm{i}.W;
        nn.b{i} = dbn.rbm{i}.c;
    end
end

