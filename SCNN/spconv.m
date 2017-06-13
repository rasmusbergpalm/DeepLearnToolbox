function [ sparse_matrix_out ] = spconv( sparse_matrix_1, sparse_matrix_2, mode )
    %sparse_matrix_2ONV 稀疏矩阵的卷积
    %   适合大规模稀疏矩阵和小型矩阵的卷积
    kx = size(sparse_matrix_2,1);
    ky = size(sparse_matrix_2,2);
    sizeX = size(sparse_matrix_1,1) + size(sparse_matrix_2,1) - 1;
    sizeY = size(sparse_matrix_1,2) + size(sparse_matrix_2,2) - 1;
    sparse_matrix_out = sparse(sizeX,sizeY);
    [x,y,c] = find(sparse_matrix_2);
    [rx,ry,rc] = find(sparse_matrix_1);
    N = numel(c);
    for i = 1:N
        sparse_matrix_out = sparse_matrix_out + sparse(rx + x(i) - 1, ry + y(i) - 1, rc*c(i), sizeX, sizeY);
    end
    if strcmp(mode,'valid')
        sparse_matrix_out = sparse_matrix_out(kx:end-(kx-1),ky:end-(ky-1));
    end
end

