function x = normalize(x, mu, sigma)
    x=bsxfun(@minus,x,mu);
	x=bsxfun(@rdivide,x,sigma);
end
