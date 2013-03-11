function nn = nnapplygrads(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases

    % Evaluation of the normalization constant for the momentum term (different for each layer)
    norm_constant=[];
    if nn.momentum~=0
        if nn.normalize_momentum==1
            norm_dE=nan(1,nn.n-1);
            norm_vW=nan(1,nn.n-1);
            for ii = 1 : nn.n-1
                dE = nn.dW{ii} + nn.weightPenaltyL2 * nn.W{ii};
                norm_dE(ii) = norm(dE(:),2); % Vector (not matrix) norm of the error
                norm_vW(ii) = norm(nn.vW{ii}(:),2);
            end
            norm_constant=(nn.learningRate.*norm_dE)./norm_vW;
        else
            norm_constant=ones(size(nn.size(1:end-1)));
        end
    end
    
    for i = 1 : (nn.n - 1)
        if(nn.weightPenaltyL2>0)
            dW = nn.learningRate * (nn.dW{i} + nn.weightPenaltyL2 * nn.W{i});
        else
            dW = nn.learningRate * nn.dW{i};
        end
        
        if(nn.momentum>0)
            nn.vW{i} = dW + nn.momentum * norm_constant(i) * nn.vW{i};
        else
            nn.vW{i} = dW;
        end
            
        nn.W{i} = nn.W{i} - nn.vW{i};
    end
end
