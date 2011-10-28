function net = dbnsetup(net, x)
    n = size(x, 2);
    net.sizes = [n, net.sizes];
    
    for u=1:numel(net.sizes)-1
        net.rbm{u}.lr = 0.1;
        net.rbm{u}.W = zeros(net.sizes(u+1), net.sizes(u));
        net.rbm{u}.b = zeros(net.sizes(u), 1);
        net.rbm{u}.c = zeros(net.sizes(u+1), 1);
    end
%     if(nargin>2) %labels
%         net.rbm{end}.Wl = zeros(net.sizes(end),size(y,2));
%         net.rbm{end}.bl = zeros(size(y,2), 1);
%     end
end