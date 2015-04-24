%relu
function out = relu(X)
% Params:
% X - input val
out = max(X,0) + nn.neg_slope *X;
end
