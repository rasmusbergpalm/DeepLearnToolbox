function nn = nnbp_grbm(nn)
%NNBP performs backpropagation
% nn = nnbp(nn) returns an neural network structure with updated weight 
% and bias gradients (nn.dW and nn.db)
    
    n = nn.n;
    sparsityError = 0;
    switch nn.output
        case 'sigm'
            d{n} = - nn.e .* (nn.a{n} .* (1 - nn.a{n}));
        case {'softmax','linear'}
             d{n} = - nn.e;
    end
    for i = (n - 1) : -1 : 3
        if(nn.nonSparsityPenalty>0)
            pi = repmat(nn.p{i}, size(nn.a{i}, 1), 1);
            sparsityError = nn.nonSparsityPenalty * (-nn.sparsityTarget ./ pi + (1 - nn.sparsityTarget) ./ (1 - pi));
        end
        d{i} = (d{i + 1} * nn.W{i} + sparsityError) .* (nn.a{i} .* (1 - nn.a{i}));
    end
    
    for i=2
        d{i} = (d{i + 1} * nn.W{i}' + sparsityError);        
    end

    for i = 1 : (n - 1)
        nn.dW{i} = (d{i + 1}' * nn.a{i}) / size(d{i + 1}, 1);
        nn.db{i} = sum(d{i + 1}, 1)' / size(d{i + 1}, 1);
    end
end
