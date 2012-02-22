function X=flipall(X)
    for i=1:ndims(X)
        X = flipdim(X,i);
    end
end