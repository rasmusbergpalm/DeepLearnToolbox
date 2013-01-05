function X = whiten(X, fudgefactor)
    C = cov(X);
    M = mean(X);
    [V,D] = eig(C);
    P = V * diag(sqrt(1./(diag(D) + fudgefactor))) * V';
    X = bsxfun(@minus, X, M) * P;
end