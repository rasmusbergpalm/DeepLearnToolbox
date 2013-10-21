clear;clc;
addpath(genpath('..'));
load('nn','nn');
%% To generate samples from the model, we perform alternating Gibbs sampling 
% in the top-level associative memory until the Markov chain converges to
% the equilibrium distribution (1000 iterations)
label=zeros(10,1);
label(7)=1;
rbm.c=0;
rbm.b=0;
alpha=0.001;
rbm.W=nn.W{end};
for iter=1:10000
    v1 = label';
    h1 = sigmrnd(rbm.c + v1*rbm.W);
    v2 = sigmrnd(rbm.b + h1*rbm.W');
    h2 = sigmrnd(rbm.c + v2*rbm.W);
    
    c1 = h1' * v1;
    c2 = h2' * v2;
    
    rbm.vW =alpha * (c1 - c2)    ;
    rbm.vb =alpha * sum(v1 - v2)';
    rbm.vc =alpha * sum(h1 - h2)' ;

    rbm.W = rbm.W + rbm.vW';
    rbm.b = rbm.b + rbm.vb;
    rbm.c = rbm.c + rbm.vc;    
end


h2=sigm(rbm.c + v2*rbm.W);
sum(h2)
%% Then we use asample from this distribution
%as input to the layers below and generate an image by a single down-pass
%through the generative connections
% 
 h3 = sigm(h2(2:end)*nn.W{end-1});
 sum(h3)
 h4 = sigm(h3(2:end)*nn.W{end-2});

 im=reshape(h4(2:end),28,28);
 imagesc(im');colormap(gray);