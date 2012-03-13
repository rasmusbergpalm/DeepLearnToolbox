%%  mnist data
clear all; close all; clc;

load ../data/mnist_uint8;

x = cell(100, 1);
N = 600;

for i = 1 : 100
    x{i}{1} = reshape(train_x(((i - 1) * N + 1) : (i) * N, :), N, 28, 28) * 255;
end

%%  ex 1
spae = {
    struct('outputmaps', 10, 'inputkernel', [1 5 5], 'outputkernel', [1 5 5], 'scale', [1 2 2], 'sigma', 0.1, 'momentum', 0.9, 'noise', 0)
};

opts.rounds     = 1000;
opts.batchsize  =    1;
opts.alpha      = 0.01;
opts.ddinterval =   10;
opts.ddhist     =  0.5;
spae = spaesetup(spae, x, opts);
spae = spaetrain(spae, x, opts);
pae = spae{1};

%Visualize the average reconstruction error
plot(pae.rL);

%Visualize the output kernels
ff = [];
for i = 1 : numel(pae.ok{1}); 
    mm = pae.ok{1}{i}(1, :, :); 
    ff(i, :) = mm(:); 
end

figure; visualize(ff', 1)
