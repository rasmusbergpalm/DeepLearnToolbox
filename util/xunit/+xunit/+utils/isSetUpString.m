function tf = isSetUpString(str)
%isSetUpString True if string looks like the name of a setup function
%   tf = isSetUpString(str) returns true if the string str looks like the name
%   of a setup function.  If str is a cell array of strings, then isSetUpString
%   tests each string in the cell array, returning the results in a logical
%   array with the same size as str.

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

setup_exp = '^[sS]et[uU]p';
tf = xunit.utils.containsRegexp(str, setup_exp);
