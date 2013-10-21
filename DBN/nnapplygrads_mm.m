function nn = nnapplygrads_mm(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases
 for mm=1:length(nn.net)
    for i = 1 : (nn.net{1}.n - 2)
        if(nn.weightPenaltyL2>0)
            dW = nn.net{mm}.dW{i} + nn.net{mm}.weightPenaltyL2 * nn.net{mm}.W{i};
        else
            dW = nn.net{mm}.dW{i};
        end
        
        dW = nn.net{mm}.learningRate * dW;
        db = nn.net{mm}.learningRate * nn.net{mm}.db{i};
        
        if(nn.net{mm}.momentum>0)
            nn.net{mm}.vW{i} = nn.net{mm}.momentum*nn.net{mm}.vW{i} + dW;
            nn.net{mm}.vb{i} = nn.net{mm}.momentum*nn.net{mm}.vb{i} + db;
            dW = nn.net{mm}.vW{i};
            db = nn.net{mm}.vb{i};
        end
            
        nn.net{mm}.W{i} = nn.net{mm}.W{i} - dW;
        nn.net{mm}.b{i} = nn.net{mm}.b{i} - db; 
    end    
 end    

    %% penultimate layer
      i=nn.net{1}.n - 1;

        if(nn.weightPenaltyL2>0)
            dW = nn.dW + nn.weightPenaltyL2 * nn.W;
        else
            dW = nn.dW;
        end
        
        dW = nn.learningRate * dW;
        db = nn.learningRate * nn.db;
        
        if(nn.momentum>0)
            nn.vW = nn.momentum*nn.vW + dW;
            nn.vb = nn.momentum*nn.vb + db;
            dW = nn.vW;
            db = nn.vb;
        end
            
        nn.W = nn.W - dW;
        nn.b = nn.b - db; 


end
