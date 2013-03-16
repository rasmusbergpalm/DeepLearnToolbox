function dbn = dbntrain(dbn, x, opts)
%% DBNTRAIN train deep belief network
% fast (unsupervised) pre-training, layer-by-layer
% later unfold to NN
% train RBM:

    n = numel(dbn.rbm);
    dbn.rbm{1} = rbmtrain(dbn.rbm{1}, x, dbn);
    for i = 2 : n
        x = rbmup(dbn.rbm{i - 1}, x);
        dbn.rbm{i} = rbmtrain(dbn.rbm{i}, x, dbn);
    end
end
