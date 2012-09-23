%TestSuiteInDir Test suite requiring temporary directory change
%   The TestSuiteInDir class defines a test suite that has to be run by first
%   changing to a specified directory.
%
%   The setUp method adds the starting directory to the path and then uses cd to
%   change into the specified directory.  The tearDown method restores the
%   original path and directory.
%
%   TestSuiteInDir methods:
%       TestSuiteInDir  - Constructor
%       gatherTestCases - Add test cases found in the target directory
%
%   See also TestSuite

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

classdef TestSuiteInDir < TestSuite & TestComponentInDir
    
    methods
        function self = TestSuiteInDir(testDirectory)
            %TestCaseInDir Constructor
            %   TestCaseInDir(testName, testDirectory) constructs a test case
            %   using the specified name and located in the specified directory.
            self = self@TestComponentInDir(testDirectory);
            
            if strcmp(testDirectory, '.')
                self.Name = pwd;
                self.Location = pwd;
            else
                [pathstr, name] = fileparts(testDirectory);
                self.Name = name;
                self.Location = testDirectory;
            end
        end
        
        function gatherTestCases(self)
            %gatherTestCases Add test cases found in the target directory
            %   suite.gatherTestCases() automaticall finds all the test cases in
            %   the directory specified in the constructor call and adds them to
            %   the suite.
            current_dir = pwd;
            c = onCleanup(@() cd(current_dir));
            
            cd(self.TestDirectory);
            tmp = TestSuite.fromPwd();
            self.TestComponents = tmp.TestComponents;
        end
    end
end
