function B = expand(A, S)
%EXPAND Replicate and tile each element of an array, similar to repmat.
% EXPAND(A,SZ), for array A and vector SZ replicates each element of A by
% SZ.  The results are tiled into an array in the same order as the 
% elements of A, so that the result is size:  size(A).*SZ. Therefore the 
% number of elements of SZ must equal the number of dimensions of A, or in 
% MATLAB syntax: length(size(A))==length(SZ) must be true.  
% The result will have the same number of dimensions as does A.  
% There is no restriction on the number of dimensions for input A.
% 
% Examples:
%
%   A = [1 2; 3 4]; % 2x2
%   SZ = [6 5];
%   B = expand(A,[6 5]) % Creates a 12x10 array.
%
%   The following demonstrates equivalence of EXPAND and expansion acheived
%   through indexing the individual elements of the array:
%
%   A = 1; B = 2; C = 3; D = 4;  % Elements of the array to be expanded.
%   Mat = [A B;C D];  % The array to expand.
%   SZ = [2 3];  % The expansion vector.
%   ONES = ones(SZ);  % The index array.
%   ExpMat1 = [A(ONES),B(ONES);C(ONES),D(ONES)]; % Element expansion.
%   ExpMat2 = expand(Mat,SZ); % Calling EXPAND.
%   isequal(ExpMat1,ExpMat2)  % Yes
%
%
% See also, repmat, meshgrid, ones, zeros, kron
%
% Author: Matt Fig
% Date: 6/20/2009
% Contact:  popkenai@yahoo.com

if nargin < 2
    error('Size vector must be provided.  See help.');
end

SA = size(A);  % Get the size (and number of dimensions) of input.

if length(SA) ~= length(S)
   error('Length of size vector must equal ndims(A).  See help.')
elseif any(S ~= floor(S))
   error('The size vector must contain integers only.  See help.')
end

T = cell(length(SA), 1);
for ii = length(SA) : -1 : 1
    H = zeros(SA(ii) * S(ii), 1);   %  One index vector into A for each dim.
    H(1 : S(ii) : SA(ii) * S(ii)) = 1;   %  Put ones in correct places.
    T{ii} = cumsum(H);   %  Cumsumming creates the correct order.
end

B = A(T{:});   %  Feed the indices into A.