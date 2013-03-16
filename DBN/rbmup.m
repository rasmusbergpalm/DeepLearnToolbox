function x = rbmup(rbm, x)
%% RBMUP propagate value x to next layer
% layers are trained one after another
    x = sigm(repmat(rbm.c', size(x, 1), 1) + x * rbm.W');
end
