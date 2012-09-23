function tf = containsRegexp(str, exp)
%containsRegexp True if string contains regular expression
%   TF = containsRegexp(str, exp) returns true if the string str contains the
%   regular expression exp.  If str is a cell array of strings, then
%   containsRegexp tests each string in the cell array, returning the results in
%   a logical array with the same size as str.

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

% Convert to canonical input form: A cell array of strings.
if ~iscell(str)
   str = {str};
end

matches = regexp(str, exp);
tf = ~cellfun('isempty', matches);
