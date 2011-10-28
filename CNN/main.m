clear all; close all; clc; dbstop if error
addpath(genpath('../util'));
addpath(genpath('../vendors'));
addpath('../data');
load mnist;

net.layers = {
    struct('type', 'i')    
    struct('type', 'c', 'outputmaps', 4, 'kernelsize', 5)
    struct('type', 's', 'scale', 2)
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5)
%     struct('type', 's', 'scale', 2)
};
train_x = reshape(train_x,50000,28,28);
test_x = reshape(test_x,10000,28,28);

% net = cnnsetup(net, train_x, train_y);

disp 'training';
for i=1:30
    net = cnntrain(net, train_x, train_y);
end
disp 'done training';

[er, bad] = cnntest(net, test_x, test_y);

% for j=1:numel(net.layers{2}.a); imshow(net.layers{4}.a{j}); drawnow; pause(0.05); end
