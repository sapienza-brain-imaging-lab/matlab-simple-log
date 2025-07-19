%DEBUG Log a debug message
%   LOG.DEBUG(message) logs a message at the Debug level using the
%   current logger instance. This is a convenience function that wraps
%   the logAtLevel method with the Debug severity level.
%
%   LOG.DEBUG(format, args...) allows sprintf-style formatting where the
%   first argument is a format string and subsequent arguments are
%   substituted into the format string.
%
%   LOG.DEBUG(..., 'Source', sourceName) allows specification of the
%   message source component.
%
%   Examples:
%       log.debug('Entering function calculateResults');
%       log.debug('Variable x = %f, y = %f', x, y);
%       log.debug('Cache hit for key %s', cacheKey, 'Source', 'CacheManager');
%
%   Debug messages are typically used for:
%   - Detailed execution flow information
%   - Variable state dumps
%   - Performance timing information
%   - Detailed diagnostic information
%
%   Note: Debug messages are only displayed when the logger's level is
%   set to Debug. They are filtered out at higher logging levels.
%
%   See also: log.info, log.warn, log.error, log.logger.logAtLevel
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

function debug (varargin)
    % LOG.DEBUG - Log a debug message
    % This function provides a convenient interface for logging messages
    % at the Debug level without requiring explicit logger access.
    
    % Forward all arguments to the logAtLevel method of the current logger
    % The varargin cell array contains:
    % - Message text or format string
    % - Optional format arguments for sprintf
    % - Optional name-value pairs (e.g., 'Source', value)
	logAtLevel(log.logger.Current, log.level.Debug, varargin{:});
end