% UTILS Utility package for MATLAB xUnit Test Framework
%
% Array Comparison
%   compareFloats            - Compare floating-point arrays using tolerance
%
% Test Case Discovery Functions
%   isTestCaseSubclass       - True for name of TestCase subclass
%
% String Functions
%   arrayToString            - Convert array to string for display
%   comparisonMessage        - Assertion message string for comparing two arrays
%   containsRegexp           - True if string contains regular expression
%   isSetUpString            - True for string that looks like a setup function
%   isTearDownString         - True for string that looks like teardown function
%   isTestString             - True for string that looks like a test function
%   stringToCellArray        - Convert string to cell array of strings
%
% Miscellaneous Functions
%   generateDoc              - Publish test scripts in mtest/doc
%   parseFloatAssertInputs   - Common input-parsing logic for several functions

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

