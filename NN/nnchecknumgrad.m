function nnchecknumgrad(nn, x, y)
    epsilon = 1e-4;
    er = 1e-9;
    n = nn.n;
    for l = 1 : (n - 1)
        for i = 1 : size(nn.W{l}, 1)
            for j = 1 : size(nn.W{l}, 2)
                nn_m = nn; nn_p = nn;
                nn_m.W{l}(i, j) = nn.W{l}(i, j) - epsilon;
                nn_p.W{l}(i, j) = nn.W{l}(i, j) + epsilon;
                nn_m = nnff(nn_m, x, y);
                nn_p = nnff(nn_p, x, y);
                dW = (nn_p.L - nn_m.L) / (2 * epsilon);
                e = abs(dW - nn.dW{l}(i, j));
                if e > er
                    error('numerical gradient checking failed');
                end
            end
        end

        for i = 1 : size(nn.b{l}, 1)
            nn_m = nn; nn_p = nn;
            nn_m.b{l}(i) = nn.b{l}(i) - epsilon;
            nn_p.b{l}(i) = nn.b{l}(i) + epsilon;
            nn_m = nnff(nn_m, x, y);
            nn_p = nnff(nn_p, x, y);
            db = (nn_p.L - nn_m.L) / (2 * epsilon);
            e = abs(db - nn.db{l}(i));
            if e > er
                error('numerical gradient checking failed');
            end
        end
    end
end
