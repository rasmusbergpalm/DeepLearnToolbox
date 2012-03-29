function [X, fX] = nngraddescent(f, X, alpha, N, opts)

    for i = 1 : N
        [fX grad_f] = f(X);

        X = X - alpha * grad_f';
    end
end
