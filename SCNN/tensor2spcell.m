function spcell = tensor2spcell(T)
n = size(T,3);
spcell = cell(1,n);
for i = 1:n
    spcell{i} = sparse(T(:,:,i));
end
end