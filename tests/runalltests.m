clear all; close all; clc;

addpath(genpath('.'));
dirlist = dir('tests/test_*');
for i = 1:length(dirlist)
    name = dirlist(i).name(1:end-2);
    feval(name)
end
