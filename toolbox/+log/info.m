%INFO Log an informational message
%   LOG.INFO(message) logs a message at the Information level using the
%   current logger instance. This is a convenience function that wraps
%   the logAtLevel method with the Information severity level.
%
%   LOG.INFO(format, args...) allows sprintf-style formatting where the
%   first argument is a format string and subsequent arguments are
%   substituted into the format string.
%
%   LOG.INFO(..., 'Source', sourceName) allows specification of the
%   message source component.
%
%   Examples:
%       log.info('Application started successfully');
%       log.info('Processing %d items', itemCount);
%       log.info('User %s logged in', username, 'Source', 'AuthSystem');
%
%   This function is typically used for:
%   - Confirming successful operations
%   - Reporting progress or status
%   - General informational messages that users should see
%
%   See also: log.debug, log.warn, log.error, log.logger.logAtLevel
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

function info (varargin)
    % LOG.INFO - Log an informational message
    % This function provides a convenient interface for logging messages
    % at the Information level without requiring explicit logger access.
    
    % Forward all arguments to the logAtLevel method of the current logger
    % The varargin cell array contains:
    % - Message text or format string
    % - Optional format arguments for sprintf
    % - Optional name-value pairs (e.g., 'Source', value)
	logAtLevel(log.logger.Current, log.level.Information, varargin{:});
end