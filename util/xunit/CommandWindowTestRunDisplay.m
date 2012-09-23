classdef CommandWindowTestRunDisplay < TestRunDisplay
    %CommandWindowTestRunDisplay Print test suite execution results to Command Window.
    %   CommandWindowTestRunDisplay is a subclass of TestRunMonitor.  If a
    %   CommandWindowTestRunDisplay object is passed to the run method of a
    %   TestComponent, such as a TestSuite or a TestCase, it will print information
    %   to the Command Window as the test run proceeds.
    %
    %   CommandWindowTestRunDisplay methods:
    %       testComponentStarted  - Update Command Window display
    %       testComponentFinished - Update Command Window display
    %       testCaseFailure       - Log test failure information
    %       testCaseError         - Log test error information
    %
    %   CommandWindowTestRunDisplay properties:
    %       TestCaseCount         - Number of test cases executed
    %       Faults                - Struct array of test fault info
    %
    %   See also TestRunLogger, TestRunMonitor, TestSuite
    
    %   Steven L. Eddins
    %   Copyright 2008-2010 The MathWorks, Inc.
    
    methods
        function self = CommandWindowTestRunDisplay
            self = self@TestRunDisplay(1);
        end
    end
    
end

