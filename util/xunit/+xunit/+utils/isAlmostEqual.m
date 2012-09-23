function same = isAlmostEqual(A, B, reltol)
%isAlmostEqual Equality test using relative tolerance
%   same = isAlmostEqual(A, B, reltol), for two floating-point arrays A and B,
%   tests A and B for equality using the specified relative tolerance.
%   isAlmostEqual returns true if the following relationship is satisfied for
%   all values in A and B:
%
%       abs(A - B) ./ max(abs(A), abs(B)) <= reltol
%
%   same = isAlmostEqual(A, B) uses the following value for the relative
%   tolerance:
%
%       100 * max(eps(class(A)), eps(class(B)))
%
%   If either A or B is not a floating-point array, then isAlmostEqual returns
%   the result of isequal(A, B).

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

if ~isfloat(A) || ~isfloat(B)
    same = isequal(A, B);
    return
end

if nargin < 3
    reltol = 100 * max(eps(class(A)), eps(class(B)));
end

if ~isequal(size(A), size(B))
    same = false;
    return
end

A = A(:);
B = B(:);

delta = abs(A - B) ./ max(max(abs(A), abs(B)), 1);

% Some floating-point values require special handling.
delta((A == 0) & (B == 0)) = 0;
delta(isnan(A) & isnan(B)) = 0;
delta((A == Inf) & (B == Inf)) = 0;
delta((A == -Inf) & (B == -Inf)) = 0;

same = all(delta <= reltol);
