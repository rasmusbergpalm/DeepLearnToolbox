function net = scnnbp(net, y)
n = numel(net.layers);

%   error
net.e = net.o - y;
%  loss function
net.L = 1/2* sum(net.e(:) .^ 2) / size(net.e, 2);

%%  backprop deltas
net.od = net.e .* (net.o .* (1 - net.o));   %  output delta
net.fvd = (net.ffW' * net.od);              %  feature vector delta
if strcmp(net.layers{n}.type, 'c')         %  only conv layers has sigm function
    net.fvd = net.fvd .* (net.fv .* (1 - net.fv));
end

%  reshape feature vector deltas into output map style
sa = sptsize(net.layers{n}.a{1});
fvnum = sa(1) * sa(2);
for j = 1 : numel(net.layers{n}.a)
    net.layers{n}.d{j} = tensor2spcell(reshape(net.fvd(((j - 1) * fvnum + 1) : j * fvnum, :), sa(1), sa(2), sa(3)));
end

for l = (n - 1) : -1 : 1
    if strcmp(net.layers{l}.type, 'c')
        for j = 1 : numel(net.layers{l}.a)
            expand_param =  [net.layers{l + 1}.scale net.layers{l + 1}.scale];
            expanded_delta = spcell_expand(net.layers{l + 1}.d{j},expand_param);
            net.layers{l}.d{j} = spcell_mul(spcell_mul(net.layers{l}.a{j},spcell_sub(1,net.layers{l}.a{j})),...
                spcell_div(expanded_delta,net.layers{l + 1}.scale ^ 2));
        end
    elseif strcmp(net.layers{l}.type, 's')
        for i = 1 : numel(net.layers{l}.a)
            z = sptzeros(sptsize(net.layers{l}.a{1}));
            for j = 1 : numel(net.layers{l + 1}.a)
                z = spcell_add(z,spconvn(net.layers{l + 1}.d{j}, rot180(net.layers{l + 1}.k{i}{j}), 'full'));
            end
            net.layers{l}.d{i} = z;
        end
    end
end

%%  calc gradients
for l = 2 : n
    if strcmp(net.layers{l}.type, 'c')
        for j = 1 : numel(net.layers{l}.a)
            n_iter_i = numel(net.layers{l - 1}.a);
            spcell_temp = cell(1,n_iter_i);
            parfor i = 1 : n_iter_i
                spcell_temp{i} =  spconvn(sptflipall(net.layers{l - 1}.a{i}),net.layers{l}.d{j}, 'valid') / size(net.layers{l}.d{j}, 3);
            end
            for i = 1:n_iter_i
                net.layers{l}.dk{i}{j} = spcell_temp{i};
            end
            net.layers{l}.db{j} = sptsum(net.layers{l}.d{j}) / numel(net.layers{l}.d{j});
        end
    end
end
net.dffW = net.od * (net.fv)' / size(net.od, 2);
net.dffb = mean(net.od, 2);

    function X = rot180(X)
        X = flip(flip(X, 1), 2);
    end
end
