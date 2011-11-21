function x=randcorr(n,R)
% RANDCORR Generates corremlated random variables
% Generates n vector valued variates with uniform marginals and correlation
% matrix R.
% Returns an nxk matrix, where k is the order of R.
  k=size(R,1);
  R=2*sin((pi/6)*R);
  x=normcdf(randn(n,k)*chol(R));