function msg = comparisonMessage(user_message, assertion_message, A, B)
%comparisonMessage Generate assertion message when comparing two arrays.
%   msg = comparisonMessage(user_message, assertion_message, A, B) returns a
%   string appropriate to use in a call to throw inside an assertion function
%   that compares two arrays A and B.
%
%   The string returned has the following form:
%
%       <user_message>
%       <assertion_message>
%
%       First input:
%       <string representation of value of A>
%
%       Second input:
%       <string representation of value of B>
%
%   user_message can be the empty string, '', in which case user_message is
%   skipped.

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

msg = sprintf('%s\n\n%s\n%s\n\n%s\n%s', ...
    assertion_message, ...
    'First input:', ...
    xunit.utils.arrayToString(A), ...
    'Second input:', ...
    xunit.utils.arrayToString(B));

if ~isempty(user_message)
    msg = sprintf('%s\n%s', user_message, msg);
end
