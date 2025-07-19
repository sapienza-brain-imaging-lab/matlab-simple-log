%ERROR Log an error message and optionally throw exception
%   LOG.ERROR(message) logs a message at the Error level and throws an
%   exception. This is a convenience function that wraps the logAtLevel
%   method with the Error severity level.
%
%   LOG.ERROR(format, args...) allows sprintf-style formatting where the
%   first argument is a format string and subsequent arguments are
%   substituted into the format string.
%
%   LOG.ERROR(..., 'ThrowError', false) logs the error but suppresses
%   the exception throwing, allowing continued execution.
%
%   Examples:
%       log.error('Invalid input parameter');
%       log.error('File %s not found', filename);
%       log.error('Connection failed', 'ThrowError', false);
%
%   Error messages are typically used for:
%   - Critical failures that should halt execution
%   - Invalid input parameters
%   - File system errors
%   - Network connection failures
%   - Validation failures
%
%   By default, this function throws an MException after logging the error.
%   The exception is thrown using throwAsCaller to preserve the original
%   call stack for debugging purposes.
%
%   See also: log.debug, log.info, log.warn, log.assert, throwAsCaller
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

function error (args, options)
    % LOG.ERROR - Log an error message and optionally throw exception
    % This function logs an error message and by default throws an exception
    % to halt execution, unless specifically configured not to.
    
	arguments (Repeating)
        % Repeating arguments for message formatting
        % Can include format string and substitution arguments
		args
	end

	arguments
        % Named arguments for controlling error behavior
        % ThrowError: Whether to throw an exception after logging (default: true)
		options.ThrowError(1,1) logical = true
	end

    % Log the error message using the current logger at Error level
    % This ensures the error is recorded even if exception throwing is disabled
	logAtLevel(log.logger.Current, log.level.Error, args{:});
    
    % Conditionally throw exception based on ThrowError option
	if options.ThrowError
        % Create MException with 'log:error' identifier and message
        % Use throwAsCaller to preserve the original call stack location
        % This makes debugging easier by pointing to the actual error location
		throwAsCaller(MException('log:error', args{:}));
	end
end