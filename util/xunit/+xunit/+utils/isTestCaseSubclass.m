function tf = isTestCaseSubclass(name)
%isTestCaseSubclass True for name of a TestCase subclass
%   tf = isTestCaseSubclass(name) returns true if the string name is the name of
%   a TestCase subclass on the MATLAB path.

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

tf = false;

class_meta = meta.class.fromName(name);
if isempty(class_meta)
    % Not the name of a class
    return;
end

if strcmp(class_meta.Name, 'TestCase')
    tf = true;
else
    tf = isMetaTestCaseSubclass(class_meta);
end

function tf = isMetaTestCaseSubclass(class_meta)

tf = false;

if strcmp(class_meta.Name, 'TestCase')
    tf = true;
else
    % Invoke function recursively on parent classes.
    super_classes = class_meta.SuperClasses;
    for k = 1:numel(super_classes)
        if isMetaTestCaseSubclass(super_classes{k})
            tf = true;
            break;
        end
    end
end

