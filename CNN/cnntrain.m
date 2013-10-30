function net = cnntrain(net, train_x, train_y)
  
train_num = size(train_x, 3);  
numbatches = ceil(train_num/net.batchsize);

net.rE = zeros(net.numepochs, 1);
for i = 1 : net.numepochs
  %tic;
  kk = randperm(train_num);
  for j = 1 : numbatches
    batch_x = train_x(:, :, kk((j-1)*net.batchsize + 1 : min(j*net.batchsize, train_num)));    
    batch_y = train_y(kk((j-1)*net.batchsize + 1 : min(j*net.batchsize, train_num)), :);
    net = cnnff(net, batch_x);
    net = cnnbp(net, batch_y);
    net = cnnapplygrads(net);
    if (isempty(net.rL)), net.rL(1) = net.L; end;
    net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;      
    %disp([i j]);
  end
  %toc  
end

end
