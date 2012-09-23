%TestCaseInDir Test case requiring temporary path modification
%   The TestCaseInDir class defines a test case that has to be run by first
%   adding a specific directory to the path.
%
%   The setUp method adds the directory to the path, and the tearDown method
%   restores the original path.
%
%   TestCaseWithAddPath is used by MATLAB xUnit's own test suite in order to test
%   itself. 
%
%   TestCaseWithAddPath methods:
%       TestCaseWithAddPath - Constructor
%       setUp               - Add test directory to MATLAB path
%       tearDown            - Restore original MATLAB path
%
%   See also TestCase, TestCaseInDir

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

classdef TestCaseWithAddPath < TestCase
    properties (SetAccess = private, GetAccess = private)
        %TestDirectory - Directory to be added to the path
        TestDirectory
        
        %OriginalPath - Path prior to adding the test directory
        OriginalPath
    end

    methods
        function self = TestCaseWithAddPath(methodName, testDirectory)
            %TestCaseInDir Constructor
            %   TestCaseInDir(testName, testDirectory) constructs a test case 
            %   using the specified name and located in the specified directory.
            self = self@TestCase(methodName);
            self.TestDirectory = testDirectory;
        end

        function setUp(self)
            %setUp Add test directory to MATLAB path.
            %   test_case.setUp() saves the current path in the OriginalPath
            %   property and then adds the TestDirectory to the MATLAB path.
            self.OriginalPath = path;
            addpath(self.TestDirectory);
        end

        function tearDown(self)
            %tearDown Restore original MATLAB path
            %   test_case.tearDown() restores the saved MATLAB path.
            path(self.OriginalPath);
        end
    end
end
