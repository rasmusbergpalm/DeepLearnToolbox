function assertTrue(condition, message)
%assertTrue Assert that input condition is true
%   assertTrue(CONDITION, MESSAGE) throws an exception containing the string
%   MESSAGE if CONDITION is not true.
%
%   MESSAGE is optional.
%
%   Examples
%   --------
%   % This call returns silently.
%   assertTrue(rand < 1, 'Expected output of rand to be less than 1')
%
%   % This call throws an error.
%   assertTrue(sum(sum(magic(3))) == 0, ...
%       'Expected sum of elements of magic(3) to be 0')
%
%   See also assertEqual, assertFalse

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

if nargin < 2
   message = 'Asserted condition is not true.';
end

if ~isscalar(condition) || ~islogical(condition)
   throwAsCaller(MException('assertTrue:invalidCondition', ...
      'CONDITION must be a scalar logical value.'));
end

if ~condition
   throwAsCaller(MException('assertTrue:falseCondition', '%s', message));
end
