function z = sptsize(cell_array)
z = [size(cell_array{1}) numel(cell_array)];
end