function test_nn_gradients_are_numerically_correct
nn = nnsetup([5 3 2]);
batch_x = rand(20, 5);
batch_y = rand(20, 2);
nn = nnff(nn, batch_x, batch_y);
nn = nnbp(nn);
nnchecknumgrad(nn, batch_x, batch_y);

nn.dropoutFraction=0.5;
rng(0);
nn = nnff(nn, batch_x, batch_y);
nn = nnbp(nn);
nnchecknumgrad(nn, batch_x, batch_y);
