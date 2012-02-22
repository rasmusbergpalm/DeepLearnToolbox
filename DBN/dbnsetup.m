function net = dbnsetup(net, x, opts)
    n = size(x, 2);
    net.sizes = [n, net.sizes];
    
    for u=1:numel(net.sizes)-1
        net.rbm{u}.alpha = opts.alpha;
        net.rbm{u}.momentum = opts.momentum;
        
        net.rbm{u}.W = zeros(net.sizes(u+1), net.sizes(u));
        net.rbm{u}.vW = zeros(net.sizes(u+1), net.sizes(u));
        
        net.rbm{u}.b = zeros(net.sizes(u), 1);
        net.rbm{u}.vb = zeros(net.sizes(u), 1);
        
        net.rbm{u}.c = zeros(net.sizes(u+1), 1);
        net.rbm{u}.vc = zeros(net.sizes(u+1), 1);
    end
%     if(nargin>2) %labels
%         net.rbm{end}.Wl = zeros(net.sizes(end),size(y,2));
%         net.rbm{end}.bl = zeros(size(y,2), 1);
%     end
end