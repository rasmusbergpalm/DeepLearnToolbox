function X = max3d(X, M)
    ll = size(X);
    B=X(M);
    B=B+rand(size(B))*1e-12;
    B=(B.*(B==repmat(max(B,[],2),[1 size(B,2) 1])));
    X(M) = B;
    reshape(X,ll);
end