function pae = paeup(pae, x)
    pae.i = x;

    %  init temp vars for parrallel processing
    pa  = cell(size(pae.a));
    pi  = pae.i;
    pik = pae.ik;
    pb  = pae.b;

    for j = 1 : numel(pae.a)
        z = 0;
        for i = 1 : numel(pi)
            z = z + convn(pi{i}, pik{i}{j}, 'full');
        end
        pa{j} = sigm(z + pb{j});

        %  Max pool.
        if ~isequal(pae.scale, [1 1 1]))
            pa{j} = max3d(pa{j}, pae.M);
%            pa{j} = max3d(pa{j}, pae.scale);
%            for u = 1 : size(pa{j}, 1)
%                A = squeeze(pa{j}(u, :, :));
%                B = im2col(A, [pae.scale pae.scale], 'distinct');
%                C = (B .* (B == repmat(max(B), [pae.scale ^ 2, 1])));
%                A = col2im(C, [pae.scale pae.scale], size(A), 'distinct');
%                pa{j}(u, :, :) = A;
%            end
        end

%        %  softmax pool
%        if pae.scale ~= 1
%            for u = 1 : size(pa{j}, 1)
%                A = exp(squeeze(pa{j}(u, :, :)));
%                A = A ./ conv2(A, ones(pae.scale), 'same');
%                pa{j}(u, :, :) = A;
%            end
%        end
%{
        %  Mean pool
        z = convn(pae.a{j}, ones([1 pae.scale]) / (pae.scale ^ 2), 'valid');
        pae.a{j} = z(:, 1 : pae.scale : end, 1 : pae.scale : end);
%}
    end
    pae.a = pa;

end
