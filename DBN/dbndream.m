function dbndream(net, n)
    if(nargin<2)
        n = numel(net.sizes);
    end
    A = (1:100)'*(1:100);
    shapes = zeros(numel(net.sizes),2);
    for l=1:n
        [i,j]=find(A==net.sizes(l));
        [~,k]=min(abs(i-j));
        shapes(l,:) = [i(k) j(k)];
    end
    while 1
        h = zeros(net.sizes(n),1);
        for i=1:100
            v = sigm(net.rbm{n-1}.b + net.rbm{n-1}.W'*h); %down 
            h = sigm(net.rbm{n-1}.c + net.rbm{n-1}.W*v) + 1/i*randn(size(h));  %up
            
            subplot(n,1,1); imshow(reshape(h,shapes(n,1),shapes(n,2))); 
            subplot(n,1,2); imshow(reshape(v,shapes(n-1,1),shapes(n-1,2))');
            
            for u=(n-2):-1:1 %down
                v = sigm(net.rbm{u}.b + net.rbm{u}.W'*v); %down
                subplot(n,1,n-u+1); imshow(reshape(v,shapes(u,1),shapes(u,2))');
            end
            drawnow;
%             
        end
    end
end