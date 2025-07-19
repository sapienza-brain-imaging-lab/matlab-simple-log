%LEVEL Log level enumeration class
%   LOG.LEVEL defines the severity levels for log messages in the logging system.
%   This sealed enumeration inherits from double to allow numeric comparisons
%   for filtering messages based on their severity.
%
%   Enumeration Values:
%   - Debug (0):       Detailed information for debugging purposes
%   - Information (1): General informational messages
%   - Warning (2):     Warning messages that don't halt execution
%   - Error (3):       Error messages indicating serious problems
%
%   The numeric values allow for easy filtering where messages with level
%   >= threshold are processed. For example, setting a logger to Warning
%   level will display Warning and Error messages but filter out Debug
%   and Information messages.
%
%   Example:
%       currentLevel = log.level.Information;
%       if log.level.Error >= currentLevel
%           % This error message will be processed
%       end
%
%   See also: log.logger, log.message
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

classdef (Sealed) level < double
    % LOG.LEVEL - Enumeration of logging severity levels
    % This class defines the standard logging levels used throughout the
    % logging system. Being sealed prevents inheritance and ensures
    % consistency across the toolbox.
    
    enumeration
        % Debug level (0) - Most verbose, for detailed debugging information
        % Use for step-by-step execution details, variable dumps, etc.
		Debug		(0)
        
        % Information level (1) - General informational messages
        % Use for normal operation confirmations, status updates, etc.
		Information	(1)
        
        % Warning level (2) - Non-critical issues that should be noted
        % Use for deprecated features, recoverable errors, etc.
        Warning     (2)
        
        % Error level (3) - Critical errors that may halt execution
        % Use for exceptions, fatal errors, validation failures, etc.
        Error       (3)
    end
end