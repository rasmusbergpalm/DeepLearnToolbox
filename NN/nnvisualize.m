function nnvisualize(net)
    for i = 2 : net.n - 1
        %  backwards
        x = eye(net.size(i));
        for u = i : -1 : 2
            x = x * net.W{u - 1};
        end
        figure; visualize(x', 1);

        %  forward
        x = eye(net.size(i));
        for u = i : net.n - 1
            x = x * net.W{u}';
        end
        figure; visualize(x', 1);
    end
end
