function s = arrayToString(A)
%arrayToString Convert array to string for display.
%   S = arrayToString(A) converts the array A into a string suitable for
%   including in assertion messages.  Small arrays are converted using disp(A).
%   Large arrays are displayed similar to the way structure field values display
%   using disp.

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

if isTooBigToDisp(A)
    s = dispAsStructField(A);
else
    s = dispAsArray(A);
end

%===============================================================================
function tf = isTooBigToDisp(A)
%   Use a heuristic to determine if the array is to convert to a string using
%   disp.  The heuristic is based on the size of the array in bytes, as reported
%   by the whos function.

whos_output = whos('A');
byte_threshold = 1000;
tf = whos_output.bytes > byte_threshold;

%===============================================================================
function s = dispAsArray(A)
%   Convert A to a string using disp.  Remove leading and trailing blank lines.

s = evalc('disp(A)');
if isempty(s)
    % disp displays nothing for some kinds of empty arrays.
    s = dispAsStructField(A);
else
    s = postprocessDisp(s);
end

%===============================================================================
function s = dispAsStructField(A)
%   Convert A to a string using structure field display.

b.A = A;
s = evalc('disp(b)');
s = postprocessStructDisp(s);

%===============================================================================
function out = postprocessDisp(in)
%   Remove leading and trailing blank lines from input string.  Don't include a
%   newline at the end.

lines = xunit.utils.stringToCellArray(in);

% Remove leading blank lines.
lines = removeLeadingBlankLines(lines);

% Remove trailing blank lines.
while ~isempty(lines) && isBlankLine(lines{end})
    lines(end) = [];
end

% Convert cell of strings to single string with newlines.  Don't put a newline
% at the end.
out = sprintf('%s\n', lines{1:end-1});
out = [out, lines{end}];

%===============================================================================
function out = postprocessStructDisp(in)
%   Return the portion of the display string to the right of the colon in the
%   output of the first structure field.  Input is a string.

lines = xunit.utils.stringToCellArray(in);

% Remove leading blank lines
lines = removeLeadingBlankLines(lines);

line = lines{1};
idx = find(line == ':');
out = line((idx+2):end);  % struct fields display with blank space following colon

%===============================================================================
function out = removeLeadingBlankLines(in)
%   Input and output are cell arrays of strings.

out = in;
while ~isempty(out) && isBlankLine(out{1})
    out(1) = [];
end

%===============================================================================
function tf = isBlankLine(line)
%   Input is a string.

tf = all(isspace(line));


