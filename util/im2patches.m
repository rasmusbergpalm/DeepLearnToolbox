function patches = im2patches(im,m,n)
    assert(rem(size(im,1),m)==0)
    assert(rem(size(im,2),n)==0)
    
    patches = [];
    for i=1:m:size(im,1)
        for u=1:n:size(im,2)
             patch = im(i:i+n-1,u:u+m-1);
             patches = [patches patch(:)];
        end
    end
    patches = patches';
end