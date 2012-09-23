function tf = isTearDownString(str)
%isTearDownString True if string looks like the name of a teardown function
%   tf = isTearDownString(str) returns true if the string str looks like the
%   name of a teardown function.  If str is a cell array of strings, then
%   isTearDownString tests each string in the cell array, returning the results
%   in a logical array with the same size as str.

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

setup_exp = '^[tT]ear[dD]own';
tf = xunit.utils.containsRegexp(str, setup_exp);
