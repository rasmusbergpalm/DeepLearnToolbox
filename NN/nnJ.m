function [J grad_J] = nnJ(net, X, x, y)
    layers = net.size;
    m      = size(x, 1);
    n      = net.n;

    beta   = net.beta;
    lambda = net.lambda;
    rho    = net.rho;

    net = nnrepackWb(net, X);

    [net y_hat] = nnff2(net, x, y);

    J = 1 / (2 * m) * sum(sum((y - y_hat) .* (y - y_hat)));

    if lambda ~= 0
        regularization_term = 0;
        for i = 1 : n - 1
            regularization_term = regularization_term + sum(sum(net.W{i} .^ 2));
        end

        J = J + (lambda / 2) * regularization_term;
    end

    if beta ~= 0 & rho ~= 0
        sparsity_term = 0;
%        for i = 2 : n - 1
%            sparsity_term = sparsity_term + rho       * log(rho       ./ net.rho_hat{i}) ...
%                                          + (1 - rho) * log((1 - rho) ./ (1 - net.rho_hat{i}));
%        end
        for i = 2 : n - 1
            for j = 1 : length(net.rho_hat{i})
                sparsity_term = sparsity_term + rho       * log(rho       ./ net.rho_hat{i}(j)) ...
                                              + (1 - rho) * log((1 - rho) ./ (1 - net.rho_hat{i}(j)));
            end
        end

        J = J + beta * sparsity_term;
    end

    net = nnbp2(net);

    grad_J = [];
    for i = 1 : n - 1
        grad_J = [grad_J (net.dW{i}(:)' + lambda * net.W{i}(:)') net.db{i}(:)' ];
    end
end
