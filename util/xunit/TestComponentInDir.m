%TestComponentInDir Test component requiring temporary directory change
%   The TestComponentInDir class defines a test component that has to be run by
%   first changing to a specified directory.
%
%   The setUp method adds the starting directory to the path and then uses cd to 
%   change into the specified directory.  The tearDown method restores the
%   original path and directory.
%
%   TestComponentInDir methods:
%       TestComponentInDir - Constructor
%       setUp              - Add test directory to MATLAB path
%       tearDown           - Restore original MATLAB path
%
%   See also TestComponent

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

classdef TestComponentInDir < TestComponent
    properties (SetAccess = private, GetAccess = protected)
        %TestDirectory - Directory to change to in the test fixture
        TestDirectory
        
        %OriginalPath  - Path prior to adding the starting directory
        OriginalPath
        
        %OriginalDirectory - Starting directory
        OriginalDirectory
    end

    methods
        function self = TestComponentInDir(testDirectory)
            %TestCaseInDir Constructor
            %   TestCaseInDir(testName, testDirectory) constructs a test case 
            %   using the specified name and located in the specified directory.
            self.TestDirectory = testDirectory;
        end

        function setUp(self)
            %setUp Add test directory to MATLAB path
            %   test_case.setUp() saves the current directory in the
            %   OriginalDirectory property, saves the current path in the
            %   OriginalPath property, and then uses cd to change into the test
            %   directory.
            self.OriginalDirectory = pwd;
            self.OriginalPath = path;
            addpath(pwd);
            cd(self.TestDirectory);
        end

        function tearDown(self)
            %tearDown Restore original MATLAB path and directory
            %   test_case.tearDown() restores the original path and directory.
            cd(self.OriginalDirectory);
            path(self.OriginalPath);
        end
    end
end
