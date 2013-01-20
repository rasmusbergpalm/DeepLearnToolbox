function nn = dbnunfoldtonn(dbn, outputsize)
%DBNUNFOLDTONN Unfolds a DBN to a NN
%   dbnunfoldtonn(dbn, outputsize ) returns the unfolded dbn with a final
%   layer of size outputsize added.
    if(exist('outputsize','var'))
        size = [dbn.sizes outputsize];
    else
        size = [dbn.sizes];
    end
    nn = nnsetup(size);
    for i = 1 : numel(dbn.rbm)
        nn.W{i} = dbn.rbm{i}.W;
        nn.b{i} = dbn.rbm{i}.c;
    end
end

