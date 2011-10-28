function patches = im2patches(im,m,n)
    patches = [];
    for i=1:10:n
        for u=1:10:m
             patch = im(u:u+9,i:i+9);
             patches = [patches patch(:)];
        end
    end
end