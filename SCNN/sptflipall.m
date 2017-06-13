function X = sptflipall(X)
X = flip(X);
for i = 1:length(X)
    X{i} = flip(flip(X{i},1),2);
end
end