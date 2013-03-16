function loss = loss_mse(err)
%% LOSS_MSE compute loss as mean-squared error
loss = 1/2 * sum(sum(err .^ 2)) / numel(err);
loss=loss(:); %flatten
end