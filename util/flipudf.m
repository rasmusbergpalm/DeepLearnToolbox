function y = flipudf(x)
%FLIPUD Flip matrix in up/down direction.
%   FLIPUD(X) returns X with columns preserved and rows flipped
%   in the up/down direction.  For example,
%   
%   X = 1 4      becomes  3 6
%       2 5               2 5
%       3 6               1 4
%
%   Class support for input X:
%      float: double, single
%
%   See also FLIPLR, ROT90, FLIPDIM.

%   Copyright 1984-2010 The MathWorks, Inc.
%   $Revision: 5.9.4.4 $  $Date: 2010/02/25 08:08:49 $

% if ~ismatrix(x)
%   error('MATLAB:flipud:SizeX', 'X must be a 2-D matrix.'); 
% end
y = x(end:-1:1,:);
