function [loss] = nneval(nn, loss, train_x, train_y, val_x, val_y)
%NNEVAL evaluates performance of neural network
% Returns a updated loss struct
assert(nargin == 4 || nargin == 6, 'Wrong number of arguments');

nn.testing = 1;
% training performance
nn                    = nnff(nn, train_x, train_y);
loss.train.e(end + 1) = nn.L;

% validation performance
if nargin == 6
    nn                    = nnff(nn, val_x, val_y);
    loss.val.e(end + 1)   = nn.L;
end
nn.testing = 0;
%calc misclassification rate if softmax
if strcmp(nn.output,'softmax')
    [er_train, dummy]               = nntest(nn, train_x, train_y);
    loss.train.e_frac(end+1)    = er_train;
    
    if nargin == 6
        [er_val, dummy]             = nntest(nn, val_x, val_y);
        loss.val.e_frac(end+1)  = er_val;
    end
end

end
