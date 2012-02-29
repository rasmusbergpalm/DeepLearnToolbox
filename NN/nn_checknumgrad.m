function nn_checknumgrad(net, x, y)
    epsilon = 1e-4;
    er = 1e-9;
    n = net.n;
    for l = 1 : (n - 1)
        for i = 1 : size(net.W{l}, 1)
            for j = 1 : size(net.W{l}, 2)
                net_m = net; net_p = net;
                net_m.W{l}(i, j) = net.W{l}(i, j) - epsilon;
                net_p.W{l}(i, j) = net.W{l}(i, j) + epsilon;
                net_m = nn_ff(net_m, x, y);
                net_p = nn_ff(net_p, x, y);
                dW = (net_p.L - net_m.L) / (2 * epsilon);
                e = abs(dW - net.dW{l}(i, j));
                if e > er
                    error('numerical gradient checking failed');
                end
            end
        end

        for i = 1 : size(net.b{l}, 1)
            net_m = net; net_p = net;
            net_m.b{l}(i) = net.b{l}(i) - epsilon;
            net_p.b{l}(i) = net.b{l}(i) + epsilon;
            net_m = nn_ff(net_m, x, y);
            net_p = nn_ff(net_p, x, y);
            db = (net_p.L - net_m.L) / (2 * epsilon);
            e = abs(db - net.db{l}(i));
            if e > er
                error('numerical gradient checking failed');
            end
        end
    end
end
