function nn = dbnunfoldtonn(dbn, outputsize)
%DBNUNFOLDTONN Unfolds a DBN to a NN
%   dbnunfoldtonn(dbn, outputsize ) returns the unfolded dbn with a final
%   layer of size outputsize added.
% aka dbn2ffnn
% outputsize (optional) - int, add output layer
    if(exist('outputsize','var'))
        size = [dbn.sizes outputsize];
    else
        size = [dbn.sizes];
    end
    nn = ffnnsetup(size);
    for i = 1 : numel(dbn.rbm)
        nn.W{i} = [dbn.rbm{i}.c dbn.rbm{i}.W]; % use weights from RBN in new FFNN
    end
end

