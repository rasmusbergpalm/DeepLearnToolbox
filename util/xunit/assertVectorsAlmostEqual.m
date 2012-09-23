function assertVectorsAlmostEqual(varargin)
%assertVectorsAlmostEqual Assert floating-point vectors almost equal in norm sense.
%   assertVectorsAlmostEqual(A, B, tol_type, tol, floor_tol) asserts that the
%   vectors A and B are equal, in the L2-norm sense and within some tolerance.
%   tol_type can be 'relative' or 'absolute'.  tol and floor_tol are scalar
%   tolerance values.
%
%   If the tolerance type is 'relative', then the tolerance test used is:
%
%       all( norm(A - B) <= tol * max(norm(A), norm(B)) + floor_tol )
%
%   If the tolerance type is 'absolute', then the tolerance test used is:
%
%       all( norm(A - B) <= tol )
%
%   tol_type, tol, and floor_tol are all optional.  The default value for
%   tol_type is 'relative'.  If both A and B are double, then the default value
%   for tol and floor_tol is sqrt(eps).  If either A or B is single, then the
%   default value for tol and floor_tol is sqrt(eps('single')).
%
%   If A or B is complex, then the tolerance test is applied independently to
%   the real and imaginary parts.
%
%   Any infinite or NaN element of A or B will cause an assertion failure.
%
%   assertVectorsAlmostEqual(A, B, ..., msg) prepends the string msg to the
%   assertion message if A and B fail the tolerance test.

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

params = xunit.utils.parseFloatAssertInputs(varargin{:});

if ~isequal(size(params.A), size(params.B))
    message = xunit.utils.comparisonMessage(params.Message, ...
        'Inputs are not the same size.', ...
        params.A, params.B);
    throwAsCaller(MException('assertVectorsAlmostEqual:sizeMismatch', ...
        '%s', message));
end

if ~(isfloat(params.A) && isfloat(params.B))
    message = xunit.utils.comparisonMessage(params.Message, ...
        'Inputs are not both floating-point.', ...
        params.A, params.B);
    throwAsCaller(MException('assertVectorsAlmostEqual:notFloat', ...
        '%s', message));
end

if ~xunit.utils.compareFloats(params.A, params.B, 'vector', ...
        params.ToleranceType, params.Tolerance, params.FloorTolerance)
    
    tolerance_message = sprintf('Inputs are not equal within %s vector tolerance: %g', ...
        params.ToleranceType, params.Tolerance);
    message = xunit.utils.comparisonMessage(params.Message, tolerance_message, ...
        params.A, params.B);
    throwAsCaller(MException('assertVectorsAlmostEqual:tolExceeded', ...
        '%s', message));
end
