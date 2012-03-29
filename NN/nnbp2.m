function net = nnbp2(net)
    n = net.n;
    beta   = net.beta;
    lambda = net.lambda;
    rho    = net.rho;

    %%  backprop
    d{n} = - net.e .* (net.a{n} .* (1 - net.a{n}));   %  are the outer parens important here?
    for i = (n - 1) : -1 : 2
%        rho_hat_i = repmat(net.rho_hat{i}, size(net.a{i}, 1), 1);
%        d{i} = (d{i + 1} * net.W{i} + beta * (-rho ./ rho_hat_i + (1 - rho) ./ (1 - rho_hat_i))) .* (net.a{i} .* (1 - net.a{i}));
        d{i} = d{i + 1} * net.W{i} .* (net.a{i} .* (1 - net.a{i}));
    end

    if beta ~= 0
        for i = (n - 1) : -1 : 2
            rho_hat_i = repmat(net.rho_hat{i}, size(net.a{i}, 1), 1);
            d{i} = d{i} + beta * (-rho ./ rho_hat_i + (1 - rho) ./ (1 - rho_hat_i)) .* (net.a{i} .* (1 - net.a{i}));
        end
    end

    for i = 1 : (n - 1)
        m = size(d{i + 1}, 1);

        net.dW{i} = (d{i + 1}' * net.a{i}) / m;
%        net.db{i} = sum(d{i + 1}, 1)'      / m;
        net.db{i} = mean(d{i + 1}, 1)';

%        sum(d{i + 1}, 1)' / m - mean(d{i + 1}, 1)'
    end
end
