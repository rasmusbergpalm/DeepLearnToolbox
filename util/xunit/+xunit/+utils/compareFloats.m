function result = compareFloats(varargin)
%compareFloats Compare floating-point arrays using tolerance.
%   result = compareFloats(A, B, compare_type, tol_type, tol, floor_tol)
%   compares the floating-point arrays A and B using a tolerance.  compare_type
%   is either 'elementwise' or 'vector'.  tol_type is either 'relative' or
%   'absolute'.  tol and floor_tol are the scalar tolerance values.
%
%   There are four different tolerance tests used, depending on the comparison
%   type and the tolerance type:
%
%   1. Comparison type: 'elementwise'     Tolerance type: 'relative'
%
%       all( abs(A(:) - B(:)) <= tol * max(abs(A(:)), abs(B(:))) + floor_tol )
%
%   2. Comparison type: 'elementwise'     Tolerance type: 'absolute'
%
%       all( abs(A(:) - B(:) <= tol )
%
%   3. Comparison type: 'vector'          Tolerance type: 'relative'
%
%       norm(A(:) - B(:) <= tol * max(norm(A(:)), norm(B(:))) + floor_tol
%
%   4. Comparison type: 'vector'          Tolerance type: 'absolute'
%
%       norm(A(:) - B(:)) <= tol
%
%   Note that floor_tol is not used when the tolerance type is 'absolute'.
%
%   compare_type, tol_type, tol, and floor_tol are all optional inputs.  The
%   default value for compare_type is 'elementwise'.  The default value for
%   tol_type is 'relative'.  If both A and B are double, then the default value
%   for tol is sqrt(eps), and the default value for floor_tol is eps.  If either
%   A or B is single, then the default value for tol is sqrt(eps('single')), and
%   the default value for floor_tol is eps('single').
%
%   If A or B is complex, then the tolerance test is applied independently to
%   the real and imaginary parts.
%
%   For elementwise comparisons, compareFloats returns true for two elements
%   that are both NaN, or for two infinite elements that have the same sign.
%   For vector comparisons, compareFloats returns false if any input elements
%   are infinite or NaN.

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

if nargin >= 3
    % compare_type specified.  Grab it and then use parseFloatAssertInputs to
    % process the remaining input arguments.
    compare_type = varargin{3};
    varargin(3) = [];
    if isempty(strcmp(compare_type, {'elementwise', 'vector'}))
        error('compareFloats:unrecognizedCompareType', ...
            'COMPARE_TYPE must be ''elementwise'' or ''vector''.');
    end
else
    compare_type = 'elementwise';
end

params = xunit.utils.parseFloatAssertInputs(varargin{:});

A = params.A(:);
B = params.B(:);

switch compare_type
    case 'elementwise'
        magFcn = @abs;
        
    case 'vector'
        magFcn = @norm;
        
    otherwise
        error('compareFloats:unrecognizedCompareType', ...
            'COMPARE_TYPE must be ''elementwise'' or ''vector''.');
end

switch params.ToleranceType
    case 'relative'
        coreCompareFcn = @(A, B) magFcn(A - B) <= ...
              params.Tolerance * max(magFcn(A), magFcn(B)) + ...
              params.FloorTolerance;
        
    case 'absolute'
        coreCompareFcn = @(A, B) magFcn(A - B) <= params.Tolerance;
        
    otherwise
        error('compareFloats:unrecognizedToleranceType', ...
            'TOL_TYPE must be ''relative'' or ''absolute''.');
end

if strcmp(compare_type, 'elementwise')
    compareFcn = @(A, B) ( coreCompareFcn(A, B) | bothNaN(A, B) | sameSignInfs(A, B) ) & ...
        ~oppositeSignInfs(A, B) & ...
        ~finiteAndInfinite(A, B);
else
    compareFcn = @(A, B)  coreCompareFcn(A, B) & ...
        isfinite(magFcn(A)) & ...
        isfinite(magFcn(B));
end

if isreal(A) && isreal(B)
    result = compareFcn(A, B);
else
    result = compareFcn(real(A), real(B)) & compareFcn(imag(A), imag(B));
end

result = all(result);

%===============================================================================
function out = bothNaN(A, B)

out = isnan(A) & isnan(B);

%===============================================================================
function out = oppositeSignInfs(A, B)

out = isinf(A) & isinf(B) & (sign(A) ~= sign(B));

%===============================================================================
function out = sameSignInfs(A, B)

out = isinf(A) & isinf(B) & (sign(A) == sign(B));

%===============================================================================
function out = finiteAndInfinite(A, B)

out = xor(isinf(A), isinf(B));

