function X = sptsubsample(X,scale)
n = numel(X);
for i = 1:n
    m = X{i};
    X{i} = m(1:scale:end,1:scale:end);
end