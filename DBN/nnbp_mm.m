function nn = nnbp_mm(nn)
%NNBP performs backpropagation
% nn = nnbp(nn) returns an neural network structure with updated weight 
% and bias gradients (nn.dW and nn.db)
    
    n = length(nn.a);
    sparsityError = 0;
    switch nn.output
        case 'sigm'
            d{n} = - nn.e .* (nn.a{n} .* (1 - nn.a{n}));
        case {'softmax','linear'}
             d{n} = - nn.e;
    end
    
    %% penultimate layer
    
    i=n-1;
    D=(d{i + 1} * nn.W + sparsityError) .* (nn.a{i} .* (1 - nn.a{i}));
    
    begin_frame=1;
    end_frame=[];
    
    for mm=1:length(nn.net)
        end_frame=begin_frame-1+nn.net{mm}.size(i-1);
        nn.net{mm}.d{i}=D(:,begin_frame:end_frame);
        begin_frame=end_frame+1;        
    end
    
    
    for mm=1:length(nn.net)        
        for i=(n-2):-1:3
             if(nn.net{mm}.nonSparsityPenalty>0)
                pi = repmat(nn.net{mm}.p{i}, size(nn.net{mm}.a{i}, 1), 1);
                sparsityError = nn.net{mm}.nonSparsityPenalty * (-nn.net{mm}.sparsityTarget ./ pi + (1 - nn.net{mm}.sparsityTarget) ./ (1 - pi));
            end
            nn.net{mm}.d{i} = (nn.net{mm}.d{i + 1} * nn.net{mm}.W{i} + sparsityError) .* (nn.net{mm}.a{i} .* (1 - nn.net{mm}.a{i}));            
        end       

        for i=2
            nn.net{mm}.d{i} = (nn.net{mm}.d{i + 1} * nn.net{mm}.W{i}' + sparsityError);        
        end

        for i = 1 : (n - 2)
            nn.net{mm}.dW{i} = (nn.net{mm}.d{i + 1}' * nn.net{mm}.a{i}) / size(nn.net{mm}.d{i + 1}, 1);
            nn.net{mm}.db{i} = sum(nn.net{mm}.d{i + 1}, 1)' / size(nn.net{mm}.d{i + 1}, 1);
        end
        
    end
        
         i=n-1;
%         D_2=[];
%         for mm=1:length(nn.net)     
%             D_2=[D_2 nn.net{mm}.d{i}];
%         end
        
        nn.dW=  d{n}'*nn.a{i} / size(D, 1);
        nn.db = sum(d{n}, 1)' / size(D, 1);
    end


    