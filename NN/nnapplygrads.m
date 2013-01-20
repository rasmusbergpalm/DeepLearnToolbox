function nn = nnapplygrads(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases
    
    for i = 1 : (nn.n - 1)
        if(nn.weightPenaltyL2>0)
            dW = nn.dW{i} + nn.weightPenaltyL2 * nn.W{i};
        else
            dW = nn.dW{i};
        end
        
        dW = nn.learningRate * dW;
        db = nn.learningRate * nn.db{i};
        
        if(nn.momentum>0)
            nn.vW{i} = nn.momentum*nn.vW{i} + dW;
            nn.vb{i} = nn.momentum*nn.vb{i} + db;
            dW = nn.vW{i};
            db = nn.vb{i};
        end
            
        nn.W{i} = nn.W{i} - dW;
        nn.b{i} = nn.b{i} - db; 
    end
end
