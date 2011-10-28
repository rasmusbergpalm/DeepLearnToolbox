function dbnvisualize(net, n, x)
    if(nargin<3)
        x = eye(net.sizes(n+1));
    end
    for u=n:-1:1 %down
        rbm = net.rbm{u};
%         rbm.b = 0*rbm.b;
        x = rbmdown(rbm, x);
    end
    visualize(x');

end