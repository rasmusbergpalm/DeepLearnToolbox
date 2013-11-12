%%  mnist data
clear all; close all; clc;
load mnist_uint8;
x = cell(100, 1);
N = 600;
for i = 1 : 100
    x{i}{1} = reshape(train_x(((i - 1) * N + 1) : (i) * N, :), N, 28, 28) * 255;
end
%% ex 1
scae = {
    struct('outputmaps', 10, 'inputkernel', [1 5 5], 'outputkernel', [1 5 5], 'scale', [1 2 2], 'sigma', 0.1, 'momentum', 0.9, 'noise', 0)
};

opts.rounds     = 1000;
opts.batchsize  =    1;
opts.alpha      = 0.01;
opts.ddinterval =   10;
opts.ddhist     =  0.5;
scae = scaesetup(scae, x, opts);
scae = scaetrain(scae, x, opts);
cae = scae{1};

%Visualize the average reconstruction error
plot(cae.rL);

%Visualize the output kernels
ff=[];
for i=1:numel(cae.ok{1}); 
    mm = cae.ok{1}{i}(1,:,:); 
    ff(i,:) = mm(:); 
end; 
figure;visualize(ff')
