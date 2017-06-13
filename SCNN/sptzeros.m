function z = sptzeros(cell_size)
assert(numel(cell_size)==3,'shape of size!=3');
n = cell_size(3);
z = cell(n,1);
for i = 1:n
    z{i} = sparse(cell_size(1),cell_size(2));
end
end