function net = cnntrain(net, x, y)
    
    L = zeros(size(x,1),1);
    tic;
    for i=1:size(x,1)
        %feedforward
        net = cnnff(net, squeeze(x(i,:,:)), y(i,:)');
        L(i+1) = 0.01*net.L + 0.99*L(i);
%         keyboard
        %get backprop gradients
        net = cnnbp(net);
%         if(rand() < 1e-4)
%             disp 'performing numerical gradient checking...';
%             cnnnumgradcheck(net,squeeze(x(i,:,:)),y(i,:)');
%             disp 'no errors...';
%         end
        %apply gradients
        net = cnnapplygrads(net);
    end
    toc;

    plot(L)
    
end