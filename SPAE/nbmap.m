function B = nbmap(X,n)
    assert(numel(n)==3,'n should have 3 elements (x,y,z) scaling.');
    X = reshape(1:numel(X),size(X,1),size(X,2),size(X,3));
    B = zeros(size(X,1)/n(1),prod(n),size(X,2)*size(X,3)/prod(n(2:3)));
    u=1;
    p=1;
    for i=1:size(X,1)
        B(u,(p-1)*prod(n(2:3))+1:p*prod(n(2:3)),:) = im2col(squeeze(X(i,:,:)),n(2:3),'distinct');
        p=p+1;
        if(mod(i,n(1))==0)
            u=u+1;
            p=1;
        end
    end

end