function nn = nnff(nn, x, y)
%NNFF performs a feedforward pass
% nn = nnff(nn, x, y) returns an neural nnwork structure with updated
% layer activations, error and sum squared loss (nn.a, nn.e and nn.L)

    n = nn.n;
    m = size(x, 1);

    nn.a{1} = x;

    %feedforward pass
    for i = 2 : n
        nn.a{i} = sigm(repmat(nn.b{i - 1}', m, 1) + nn.a{i - 1} * nn.W{i - 1}');
        if(nn.dropoutFraction > 0 && i<n)
            if(nn.testing)
                nn.a{i} = nn.a{i}.*(1 - nn.dropoutFraction);
            else
                nn.a{i} = nn.a{i}.*(rand(size(nn.a{i}))>nn.dropoutFraction);
            end
        end
        
        %calculate running exponential activations for use with sparsity
        if(nn.nonSparsityPenalty>0)
            nn.p{i} = 0.99 * nn.p{i} + 0.01 * mean(nn.a{i}, 1);
        end
    end

    %error and loss
    nn.e = y - nn.a{n};
    nn.L = 1/2 * sum(sum(nn.e .^ 2)) / m; 
end
