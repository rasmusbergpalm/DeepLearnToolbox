function nnevalregularizers(nn, loss)
cost_prediction = loss.train.e(end);

cost_weightL2 = 0;
unitcost_weightL2 = 0;
for i = 1 : nn.n-1
    l2_reg = nn.W{i}(:,2:end).^2;
    cost_weightL2 = cost_weightL2 + 1/2 * nn.weightPenaltyL2 * sum(sum(l2_reg));
    unitcost_weightL2 = unitcost_weightL2 + sum(sum(l2_reg)) / (size(l2_reg,1)*size(l2_reg,2));
end
unitcost_weightL2 = unitcost_weightL2 / (nn.n-1);

cost_sparsity = 0;
unitcost_sparsity = 0;
for i = 2 : nn.n-1
    num_hid = numel(nn.p{i});
    kl_div_aggregated = nn.sparsityTarget * sum(log(nn.sparsityTarget ./ nn.p{i})) + (1 - nn.sparsityTarget) * sum(log((1 - nn.sparsityTarget) ./ (1 - nn.p{i})));
    cost_sparsity = cost_sparsity + nn.nonSparsityPenalty * kl_div_aggregated;
    unitcost_sparsity = unitcost_sparsity + kl_div_aggregated / num_hid;
end
unitcost_sparsity = unitcost_sparsity / (nn.n-2);

costs = [cost_prediction cost_weightL2 cost_sparsity];
total_cost = sum(costs);

fprintf('\tPercentage contributions (Prediction error, L2 regularizer, sparsity regularizer): %.1f, %.1f, %.1f;\t', 100*costs/total_cost);
fprintf('Unit costs of (L2, sparsity) regularizers: %f, %f\n', unitcost_weightL2, unitcost_sparsity);