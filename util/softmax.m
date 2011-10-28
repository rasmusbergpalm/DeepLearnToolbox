function mu = softmax(eta)
    % Softmax function
    % mu(i,c) = exp(eta(i,c))/sum_c' exp(eta(i,c'))

    % This file is from matlabtools.googlecode.com

    tmp = exp(eta);
    denom = sum(tmp, 2);
    mu = bsxfun(@rdivide, tmp, denom);

end



