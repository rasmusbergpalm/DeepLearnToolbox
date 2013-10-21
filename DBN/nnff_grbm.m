function nn = nnff_grbm(nn, x, y)
%NNFF performs a feedforward pass
% nn = nnff(nn, x, y) returns an neural network structure with updated
% layer activations, error and loss (nn.a, nn.e and nn.L)

    n = nn.n;
    m = size(x, 1);

    nn.a{1} = x;

    %feedforward pass
    for i=2
       nn.a{i} = 1./(1 + exp(-(nn.a{1}./1)*nn.W{1}' - (ones(size(nn.a{1},1),1)*nn.b{1}'))); %p(h_j =1|data) 
        
    end
    
    for i = 3 : n-1
        nn.a{i} = sigm(repmat(nn.b{i - 1}', m, 1) + nn.a{i - 1} * nn.W{i - 1}');
        if(nn.dropoutFraction > 0)
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
    switch nn.output 
        case 'sigm'
            nn.a{n} = sigm(repmat(nn.b{n - 1}', m, 1) + nn.a{n - 1} * nn.W{n - 1}');
        case 'linear'
            nn.a{n} = repmat(nn.b{n - 1}', m, 1) + nn.a{n - 1} * nn.W{n - 1}';
        case 'softmax'
            nn.a{n} = repmat(nn.b{n - 1}', m, 1) + nn.a{n - 1} * nn.W{n - 1}';
            nn.a{n} = exp(bsxfun(@minus, nn.a{n}, max(nn.a{n},[],2)));
            nn.a{n} = bsxfun(@rdivide, nn.a{n}, sum(nn.a{n}, 2)); 
    end

    %error and loss
    nn.e = double(y) - nn.a{n};
    switch nn.output
        case {'sigm','linear'}
            nn.L = 1/2 * sum(sum(nn.e .^ 2)) / m; 
        case 'softmax'
            nn.L = -sum(sum(double(y) .* log(nn.a{n}))) / m;
    end
end
