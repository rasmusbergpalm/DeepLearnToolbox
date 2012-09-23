%TestCaseInDir Test case requiring temporary directory change
%   The TestCaseInDir class defines a test case that has to be run by first
%   changing to a specified directory.
%
%   The setUp method adds the starting directory to the path and then uses cd to 
%   change into the specified directory.  The tearDown method restores the
%   original path and directory.
%
%   TestCaseInDir is used by MATLAB xUnit's own test suite in order to test itself.
%
%   TestCaseInDir methods:
%       TestCaseInDir - Constructor
%
%   See also TestCase, TestCaseWithAddPath, TestComponent

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

classdef TestCaseInDir < TestCase & TestComponentInDir

    methods
        function self = TestCaseInDir(methodName, testDirectory)
            %TestCaseInDir Constructor
            %   TestCaseInDir(testName, testDirectory) constructs a test case 
            %   using the specified name and located in the specified directory.
            self = self@TestCase(methodName);
            self = self@TestComponentInDir(testDirectory);
        end
    end
end
