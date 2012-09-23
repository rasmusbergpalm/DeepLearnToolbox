function assertFalse(condition, message)
%assertFalse Assert that input condition is false
%   assertFalse(CONDITION, MESSAGE) throws an exception containing the string
%   MESSAGE if CONDITION is not false.
%
%   MESSAGE is optional.
%
%   Examples
%   --------
%   assertFalse(isreal(sqrt(-1)))
%
%   assertFalse(isreal(sqrt(-1)), ...
%       'Expected isreal(sqrt(-1)) to be false.')
%
%   See also assertTrue

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

if nargin < 2
   message = 'Asserted condition is not false.';
end

if ~isscalar(condition) || ~islogical(condition)
   throwAsCaller(MException('assertFalse:invalidCondition', ...
      'CONDITION must be a scalar logical value.'));
end

if condition
   throwAsCaller(MException('assertFalse:trueCondition', '%s', message));
end
