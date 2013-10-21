function nn = nnff_mm(nn, x, y)
%NNFF performs a feedforward pass
% nn = nnff(nn, x, y) returns an neural network structure with updated
% layer activations, error and loss (nn.a, nn.e and nn.L)

 for mm=1:length(nn.net)
     
    n = nn.net{mm}.n;
    m = size(x{mm}, 1);

    nn.net{mm}.a{1} = x{mm};

    %%feedforward pass

    for i=2
       nn.net{mm}.a{i} = 1./(1 + exp(-(nn.net{mm}.a{1}./1)*nn.net{mm}.W{1}' - (ones(size(nn.net{mm}.a{1},1),1)*nn.net{mm}.b{1}'))); %p(h_j =1|data) 
        
    end
    
    for i = 3 : n-1 
        nn.net{mm}.a{i} = sigm(repmat(nn.net{mm}.b{i - 1}', m, 1) + nn.net{mm}.a{i - 1} * nn.net{mm}.W{i - 1}');
        if(nn.net{mm}.dropoutFraction > 0)
            if(nn.net{mm}.testing)
                nn.net{mm}.a{i} = nn.net{mm}.a{i}.*(1 - nn.net{mm}.dropoutFraction);
            else
                nn.net{mm}.a{i} = nn.net{mm}.a{i}.*(rand(size(nn.net{mm}.a{i}))>nn.net{mm}.dropoutFraction);
            end
        end
        %calculate running exponential activations for use with sparsity
        if(nn.net{mm}.nonSparsityPenalty>0)
            nn.net{mm}.p{i} = 0.99 * nn.net{mm}.p{i} + 0.01 * mean(nn.net{mm}.a{i}, 1);
        end
    end
  
 end
 
 %% Penultimate layer 
     nn.a{n-1}=[];% We don't use the final output layer!!
     for mm=1:length(nn.net)
                    nn.a{n-1}=[nn.a{n-1} nn.net{mm}.a{n-1}];
     end            
 
 
    %%
    switch nn.output 
        case 'sigm'
            nn.a{n} = sigm(repmat(nn.b{n - 1}', m, 1) + nn.a{n - 1} * nn.W{n - 1}');
        case 'linear'
            nn.a{n} = repmat(nn.b{n - 1}', m, 1) + nn.a{n - 1} * nn.W{n - 1}';
        case 'softmax'
            nn.a{n} = repmat(nn.b', m, 1) + nn.a{n - 1} * nn.W';
            nn.a{n} = exp(bsxfun(@minus, nn.a{n}, max(nn.a{n},[],2)));
            nn.a{n} = bsxfun(@rdivide, nn.a{n}, sum(nn.a{n}, 2)); 
    end

    %error and loss
    nn.e = y - nn.a{n};
    switch nn.output
        case {'sigm','linear'}
            nn.L = 1/2 * sum(sum(nn.e .^ 2)) / m; 
        case 'softmax'
            nn.L = -sum(sum(y .* log(nn.a{n}))) / m;
    end
end
