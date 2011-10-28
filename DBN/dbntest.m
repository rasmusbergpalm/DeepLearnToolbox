function [er, bad] = dbntest(net, x, y)
    m = size(x,1);
    n = numel(net.rbm);
    nl = size(y,2);
    e = 0;
    bad = [];
    
    for u=1:n-1 %up
        x = sigm(repmat(net.rbm{u}.c',m,1) + x*net.rbm{u}.W');
    end
    
    for i=1:m
        l = ones(nl,1)/nl;
        for u=1:10
            h = sigm(net.rbm{end}.c + net.rbm{end}.Wl*l + net.rbm{end}.W*x(i,:)');     %up
            l = softmax((net.rbm{end}.bl + net.rbm{end}.Wl'*h)')';                        %down
        end
        [~,g]=max(l);
        if(g ~= find(y(i,:)'))
            e = e+1;
            bad = [bad; i];
        end
    end
    er = e/m;
end