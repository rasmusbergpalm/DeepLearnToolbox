function test_nn_gradients_are_numerically_correct
batch_x = rand(20, 5);
batch_y = rand(20, 2);

batch_x=[ones(size(batch_x,1),1) batch_x];

nn = nnsetup([5 3 2]);
nn.output='sigm';
nn.activation_function='tanh_opt';
nn = nnff(nn, batch_x, batch_y);
nn = nnbp(nn);
nnchecknumgrad(nn, batch_x, batch_y);

nn = nnsetup([5 3 2]);
nn.output='linear';
nn = nnff(nn, batch_x, batch_y);
nn = nnbp(nn);
nnchecknumgrad(nn, batch_x, batch_y);

nn = nnsetup([5 3 2]);
% softmax output requires a binary output vector
y=batch_y==repmat(max(batch_y,[],2),1,size(batch_y,2));
nn.output='softmax';
nn = nnff(nn, batch_x, y);
nn = nnbp(nn);
nnchecknumgrad(nn, batch_x, y);

nn = nnsetup([5 3 2]);
nn.dropoutFraction=0.5;
rng(0);
nn = nnff(nn, batch_x, batch_y);
nn = nnbp(nn);
nnchecknumgrad(nn, batch_x, batch_y);