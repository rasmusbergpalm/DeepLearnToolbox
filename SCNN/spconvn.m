function [ sparse_array_out ] = spconvn( sparse_cellarray, sparse_matrix_kernel, mode )
    if ~iscell(sparse_matrix_kernel)
        n = numel(sparse_cellarray);
        sparse_array_out = cell(size(sparse_cellarray));
        for i = 1:n
            sparse_array_out{i} = spconv(sparse_cellarray{i},sparse_matrix_kernel, mode);
        end
    else
        assert(numel(sparse_cellarray)==numel(sparse_matrix_kernel),'unsupport conv operation.');
        assert(strcmp(mode,'valid'),'Mode is not "valid".')
        n = numel(sparse_cellarray);
        sparse_array_out = spconv(sparse_cellarray{1},sparse_matrix_kernel{1}, mode);
        for i = 2:n
             sparse_array_out = sparse_array_out + spconv(sparse_cellarray{i},sparse_matrix_kernel{i}, mode);
        end
    end
end