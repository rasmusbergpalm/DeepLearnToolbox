function nn = nnapplygrads(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases

    %  TODO add momentum
    for i = 1 : (nn.n - 1)
        nn.W{i} = nn.W{i} - nn.learningRate * (nn.dW{i} + nn.weightPenaltyL2 * nn.W{i});
        nn.b{i} = nn.b{i} - nn.learningRate * nn.db{i};
    end
end
