function im = patches2im(patches,n,m)
    k=1;
    im = zeros(n,m);
    for i=1:10:800
        for u=1:10:1140
            patch = patches(:,k); 
            im(u:u+9,i:i+9) = reshape(patch,10,10);
            k = k+1;
        end
    end
end