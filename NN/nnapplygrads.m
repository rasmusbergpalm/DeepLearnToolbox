function nn = nnapplygrads(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases
    
    for i = 1 : (nn.n - 1)
        nn.vW{i} = nn.momentum*nn.vW{i} + nn.learningRate * (nn.dW{i} + nn.weightPenaltyL2 * nn.W{i});
        nn.vb{i} = nn.momentum*nn.vb{i} + nn.learningRate * nn.db{i};
        nn.W{i} = nn.W{i} - nn.vW{i};
        nn.b{i} = nn.b{i} - nn.vb{i}; 
    end
end
