%ASSERT Assertion with integrated logging capability
%   LOG.ASSERT(condition) asserts condition and logs error if false.
%   This function extends MATLAB's built-in assert function by adding
%   automatic logging of assertion failures.
%
%   LOG.ASSERT(condition, message) uses custom error message when assertion
%   fails, both for logging and exception throwing.
%
%   LOG.ASSERT(..., 'ThrowError', false) logs the assertion failure but
%   suppresses error throwing, allowing continued execution for testing
%   or debugging scenarios.
%
%   Examples:
%       log.assert(x > 0, 'Value must be positive');
%       log.assert(isnumeric(x), 'Input must be numeric');
%       log.assert(length(data) > 0, 'Data cannot be empty', 'ThrowError', false);
%
%   This function is useful for:
%   - Parameter validation with automatic logging
%   - Precondition checks in functions
%   - Debugging assertions that need to be logged
%   - Test scenarios where assertion failures should be recorded
%
%   The function first forwards all arguments to MATLAB's built-in assert
%   function. If the assertion fails, it catches the exception, logs the
%   error message, and optionally re-throws the exception.
%
%   See also: assert, log.error, log.logger.logAtLevel
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

function assert (args, options)
    % LOG.ASSERT - Assertion with logging capability
    % This function wraps MATLAB's built-in assert function to provide
    % automatic logging of assertion failures while maintaining the
    % same interface and behavior.
    
    arguments (Repeating)
        % Repeating arguments passed directly to built-in assert
        % Typically includes: condition, message, and optional format arguments
        args            
    end

    arguments
        % Named arguments for controlling assertion behavior
        % ThrowError: Whether to throw error after logging (default: true)
        options.ThrowError(1,1) logical = true
    end

    try
        % Forward all arguments to MATLAB's built-in assert function
        % This maintains full compatibility with the standard assert interface
        % including support for condition, message, and format arguments
        assert(args{:});
        
    catch err
        % If assertion fails, log the error message at Error level
        % This ensures assertion failures are recorded in the log
        logAtLevel(log.logger.Current, log.level.Error, err.message);
        
        % Conditionally re-throw the exception based on ThrowError option
        % This allows for logging-only mode during testing or debugging
        if options.ThrowError
            % Re-throw the original exception to maintain stack trace
            % and preserve the original assert behavior
            rethrow(err);
        end
    end
end