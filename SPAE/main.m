clear all; close all; clc;

%%  natural image data
%dirs = dir('../nipsdata/resized/');
%for u = 3 : numel(dirs)
%    ims = dir(['../nipsdata/resized/' dirs(u).name '/*.png']);
%    for i = 1 : numel(ims)
%        im = imread(['../nipsdata/resized/' dirs(u).name '/' ims(i).name]);
%        x{u-2}{1}(i, :, :) = im(:, :, 1);
%    end
%end

%%  mnist data
clear all; close all; clc; dbstop if error
load ../data/mnist;
x = cell(100, 1);
N = 600;
for i = 1 : 100
    x{i}{1} = reshape(train_x(((i - 1) * N + 1) : (i) * N, :), N, 28, 28) * 255;
end

%%%  artificial data
%clear all; close all; clc;
%for u = 1 : 1000;
%    X = zeros(13, 28, 28);
%        for i = 1 : size(X, 1);
%            for uu = 1 : randi(5)
%                j = randi(23, 1, 1); 
%                k = randi(23, 1, 1); 
%                X(i, j : j + 5, k) = 255;
%                j = randi(23, 1, 1); 
%                k = randi(23, 1, 1); 
%                X(i, j, k : k + 5) = 255;
%            end
%        end;
%    x{u}{1} = X;
%end

spae = {
    struct('outputmaps', 1, 'inputkernel', [1 5 5], 'outputkernel', [1 5 5], 'scale', [1 1 1], 'sigma', 0.1, 'momentum', 0.9, 'noise', 0)
};

opts.rounds     = 1000;
opts.batchsize  =    1;
opts.alpha      = 0.01;
opts.ddinterval =   10;
opts.ddhist     = 0.5;
spae = spaesetup(spae, x, opts);
pae  = spae{1};
for i = 1 : pae.outputmaps
    pae.ik{1}{i} = zeros(size(pae.ik{1}{i}));
    pae.ik{1}{i}(1, 3, 3) = 8;
    pae.ok{1}{i} = pae.ik{1}{i};
    pae.b{i} = -4;
end
pae.c{1} = -4;
spae = {pae};

spae = spaetrain(spae, x, opts);

pae = spae{1};
