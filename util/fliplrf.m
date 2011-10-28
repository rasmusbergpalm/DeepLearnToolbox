function y = fliplrf(x)
%FLIPLR Flip matrix in left/right direction.
%   FLIPLR(X) returns X with row preserved and columns flipped
%   in the left/right direction.
%   
%   X = 1 2 3     becomes  3 2 1
%       4 5 6              6 5 4
%
%   Class support for input X:
%      float: double, single
%
%   See also FLIPUD, ROT90, FLIPDIM.

%   Copyright 1984-2010 The MathWorks, Inc.
%   $Revision: 5.9.4.4 $  $Date: 2010/02/25 08:08:47 $

% if ~ismatrix(x)
%   error('MATLAB:fliplr:SizeX', 'X must be a 2-D matrix.'); 
% end
y = x(:,end:-1:1);
