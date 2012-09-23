% MATLAB xUnit Test Framework
% Version 3.1 (R2010b) 19-Nov-2010
%
% Running Unit Tests
%   runtests                  - Run unit tests
%
% Writing Unit Tests
%   assertElementsAlmostEqual - Assert floating-point array elements almost equal
%   assertEqual               - Assert that inputs are equal
%   assertFilesEqual          - Assert that two files have the same content
%   assertExceptionThrown     - Assert that specified exception is thrown
%   assertFalse               - Assert that input condition is false
%   assertTrue                - Assert that input condition is true
%   assertVectorsAlmostEqual  - Assert floating-point vectors almost equal in norm sense
%   initTestSuite             - Utility script used for subfunction-based tests
%
% Framework Classes
%   CommandWindowTestRunDisplay - Print test suite results to command window
%   FunctionHandleTestCase    - Test case based on a function handle
%   TestCase                  - Class defining interface for test cases
%   TestCaseInDir             - Test case requiring temporary directory change
%   TestCaseWithAddPath       - Test case requiring temporary path modification
%   TestComponent             - Abstract base class for TestCase and TestSuite
%   TestComponentInDir        - Test component requiring temporary directory change
%   TestLogger                - Collect data (silently) from running test suite
%   TestRunDisplay            - Print test suite execution results
%   TestRunMonitor            - Abstract base class for monitoring test suite
%   TestSuite                 - Collection of TestComponent objects
%   TestSuiteInDir            - Test suite requiring temporary directory change
%   %VerboseTestRunDisplay    - Print test suite execution results

% Steven L. Eddins
% Copyright 2008-2010 The MathWorks, Inc.