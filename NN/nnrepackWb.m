function net = nnrepackWb(net, values)

    layers = net.size;

    offset = 1;
    for i = 2 : net.n
        m = layers(i);
        n = layers(i - 1);
        n_elements = m * n;

        net.W{i - 1} = reshape(values(offset : offset + n_elements - 1), m, n);

        offset = offset + n_elements;

        m = layers(i);
        n = 1;
        n_elements = m;

        net.b{i - 1} = reshape(values(offset : offset + n_elements - 1), m, 1);

        offset = offset + n_elements;
    end
end
