%TestRunLogger Collect data (silently) from running test suite
%   TestRunLogger is a subclass of TestRunMonitor uses to collect information 
%   from an executing test component (either a test case or a test suite).
%   It maintains a record of event notifications received, as well as any test
%   failures or test errors.
%
%   TestRunLogger methods:
%       testComponentStarted  - Log test component started
%       testComponentFinished - Log test component finished
%       testCaseFailure       - Log test case failure
%       testCaseError         - Log test case error
%
%   TestRunLogger properties:
%       Log          - Cell array of test notification strings
%       NumFailures  - Number of test failures during execution
%       NumErrors    - Number of test errors during execution
%       NumTestCases - Total number of test cases executed
%       Faults       - Struct array of test fault information
%
%   See also CommandWindowTestRunDisplay, TestRunMonitor, TestSuite

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

classdef TestRunLogger < TestRunMonitor

    properties (SetAccess = protected)  
        %Log Cell array of test notification strings
        %   Test notification strings include 'TestRunStarted',
        %   'TestRunFinished', 'TestComponentStarted', 'TestComponentFinished',
        %   'TestCaseFailure', and 'TestCaseError'.
        Log
        
        %NumFailures Number of test failures during execution
        NumFailures = 0
        
        %NumErrors Number of test errors during execution
        NumErrors = 0
        
        %NumTestCases Total number of test cases executed
        NumTestCases = 0
        
        %Faults Struct array of test fault information
        %   Faults is a struct array with the fields Type, TestCase, and
        %   Exception.  Type is either 'failure' or 'error'.  TestCase is the
        %   test case object that triggered the fault.  Exception is the
        %   MException object thrown during the fault.
        Faults = struct('Type', {}, 'TestCase', {}, 'Exception', {});
    end
    
    properties (SetAccess = private, GetAccess = private)
        InitialTestComponent = []
    end

    methods
        
        function testComponentStarted(self, component)
            if isempty(self.InitialTestComponent)
                self.InitialTestComponent = component;
                self.appendToLog('TestRunStarted');
            end
            
            self.appendToLog('TestComponentStarted');
            
            if isa(component, 'TestCase')
                self.NumTestCases = self.NumTestCases + 1;
            end
        end
            
        function testComponentFinished(self, component, did_pass)
            self.appendToLog('TestComponentFinished');
            
            if isequal(component, self.InitialTestComponent)
                self.appendToLog('TestRunFinished');
            end
        end
        
        function testCaseFailure(self, test_case, failure_exception)
            self.appendToLog('TestCaseFailure');
            self.NumFailures = self.NumFailures + 1;
            self.logFault('failure', test_case, ...
                failure_exception);
        end
        
        function testCaseError(self, test_case, error_exception)
            self.appendToLog('TestCaseError');
            self.NumErrors = self.NumErrors + 1;
            self.logFault('error', test_case, ...
                error_exception);
        end
    end
    
    methods (Access = private)
        function appendToLog(self, item)
            self.Log{end+1} = item;
        end
        
        function logFault(self, type, test_case, exception)
            self.Faults(end + 1).Type = type;
            self.Faults(end).TestCase = test_case;
            self.Faults(end).Exception = exception;
        end
    end
end
