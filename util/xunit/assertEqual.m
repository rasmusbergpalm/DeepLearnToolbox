function assertEqual(A, B, custom_message)
%assertEqual Assert that inputs are equal
%   assertEqual(A, B) throws an exception if A and B are not equal.  A and B
%   must have the same class and sparsity to be considered equal.
%
%   assertEqual(A, B, MESSAGE) prepends the string MESSAGE to the assertion
%   message if A and B are not equal.
%
%   Examples
%   --------
%   % This call returns silently.
%   assertEqual([1 NaN 2], [1 NaN 2]);
%
%   % This call throws an error.
%   assertEqual({'A', 'B', 'C'}, {'A', 'foo', 'C'});
%
%   See also assertElementsAlmostEqual, assertVectorsAlmostEqual

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

if nargin < 3
    custom_message = '';
end

if ~ (issparse(A) == issparse(B))
    message = xunit.utils.comparisonMessage(custom_message, ...
        'One input is sparse and the other is not.', A, B);
    throwAsCaller(MException('assertEqual:sparsityNotEqual', '%s', message));
end

if ~strcmp(class(A), class(B))
    message = xunit.utils.comparisonMessage(custom_message, ...
        'The inputs differ in class.', A, B);
    throwAsCaller(MException('assertEqual:classNotEqual', '%s', message));
end

if ~isequalwithequalnans(A, B)
    message = xunit.utils.comparisonMessage(custom_message, ...
        'Inputs are not equal.', A, B);
    throwAsCaller(MException('assertEqual:nonEqual', '%s', message));
end

