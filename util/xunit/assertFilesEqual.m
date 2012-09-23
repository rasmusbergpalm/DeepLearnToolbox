function assertFilesEqual(filename1, filename2, user_message)
%assertFilesEqual Assert that files contain the same contents.
%   assertFilesEqual(filename1, filename2) throws an exception if the two
%   specified files do not contain the same contents.
%
%   assertFilesEqual(filename1, filename2, message) prepends the specified
%   message string to the assertion message.

%   Steven L. Eddins
%   Copyright 2009-2010 The MathWorks, Inc.

if nargin < 3
    user_message = '';
end

fid1 = fopen(filename1, 'r');
if (fid1 < 0)
    message = sprintf('%s\nCould not open file for reading: %s', ...
        user_message, filename1);
    throwAsCaller(MException('assertFilesEqual:readFailure', ...
        '%s', message));
else
    c1 = onCleanup(@() fclose(fid1));
end

fid2 = fopen(filename2, 'r');
if (fid2 < 0)
    message = sprintf('%s\nCould not open file for reading: %s', ...
        user_message, filename2);
    throwAsCaller(MException('assertFilesEqual:readFailure', '%s', message));
else
    c2 = onCleanup(@() fclose(fid2));
end

block_size = 100000;
num_blocks = 0;
done = false;
while ~done
    block_from_file1 = fread(fid1, block_size, '*uint8');
    block_from_file2 = fread(fid2, block_size, '*uint8');
    
    if numel(block_from_file1) ~= numel(block_from_file2)
        fseek(fid1, 0, 'eof');
        fseek(fid2, 0, 'eof');
        message = sprintf('The two files are not the same size. File "%s" has %d bytes and file "%s" has %d bytes', ...
            filename1, ftell(fid1), filename2, ftell(fid2));
        if ~isempty(user_message)
            message = sprintf('%s\n%s', user_message, message);
        end
        throwAsCaller(MException('assertFilesEqual:sizeMismatch', '%s', message));
    end
    
    if ~isequal(block_from_file1, block_from_file2)
        first_difference_in_block = find(block_from_file1 ~= block_from_file2);
        first_difference = num_blocks * block_size + first_difference_in_block;
        
        message = sprintf('Files are not equal. First difference is at byte %d, where file "%s" contains 0x%X and file "%s" contains 0x%X', ...
            first_difference, filename1, block_from_file1(first_difference_in_block), ...
            filename2, block_from_file2(first_difference_in_block));
        if ~isempty(user_message)
            message = sprintf('%s\n%s', user_message, message);
        end
        throwAsCaller(MException('assertFilesEqual:valuesDiffer', '%s', message));
    end
    
    done = numel(block_from_file1) < block_size;
    num_blocks = num_blocks + 1;
end