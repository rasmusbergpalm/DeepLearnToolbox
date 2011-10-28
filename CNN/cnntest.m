function [er, bad] = cnntest(net, x, y)
    e = 0;
    bad = [];
    for i=1:size(x,1)
        %feedforward
        net = cnnff(net, squeeze(x(i,:,:)), y(i,:)');
        [~,g]=max(net.o);
        if(g ~= find(y(i,:)'))
            e = e+1;
            bad = [bad; i];
        end
    end
    er = e/size(x,1);
end