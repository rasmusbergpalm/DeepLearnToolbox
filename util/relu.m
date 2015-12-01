%relu
function out = relu(X,nn)
% Params:
% X - input val
if isempty(nn.neg_slope)
    nn.neg_slope = 0;
end
out = max(X,0) + nn.neg_slope *X;
end
