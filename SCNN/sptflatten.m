function spout = sptflatten(X)
splen = size(X{1});
splen = splen(1)*splen(2);
n = numel(X);
spout = sparse(splen,n);
for i = 1:n
    spout(:,i) = reshape(X{i},splen,1);
end
end