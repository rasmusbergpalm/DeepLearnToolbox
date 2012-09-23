function c = stringToCellArray(s)
%stringToCellArray Convert string with newlines to cell array of strings.
%   C = stringToCellArray(S) converts the input string S to a cell array of
%   strings, breaking up S at new lines.

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

if isempty(s)
    c = cell(0, 1);
else
    c = textscan(s, '%s', 'Delimiter', '\n', 'Whitespace', '');
    c = c{1};
end
