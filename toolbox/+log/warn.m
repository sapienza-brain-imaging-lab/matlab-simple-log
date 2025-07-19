%WARN Log a warning message
%   LOG.WARN(message) logs a message at the Warning level using the
%   current logger instance. This is a convenience function that wraps
%   the logAtLevel method with the Warning severity level.
%
%   LOG.WARN(format, args...) allows sprintf-style formatting where the
%   first argument is a format string and subsequent arguments are
%   substituted into the format string.
%
%   LOG.WARN(..., 'Source', sourceName) allows specification of the
%   message source component.
%
%   Examples:
%       log.warn('Configuration file not found, using defaults');
%       log.warn('Memory usage is %d%% of available', memoryPercent);
%       log.warn('Deprecated function called', 'Source', 'LegacyAPI');
%
%   Warning messages are typically used for:
%   - Non-critical issues that don't halt execution
%   - Deprecated feature usage
%   - Recoverable errors or fallback situations
%   - Resource usage concerns
%   - Configuration issues that can be worked around
%
%   Warning messages are displayed at Warning level and above (Warning, Error).
%   They are filtered out when the logger level is set to Error only.
%
%   See also: log.debug, log.info, log.error, log.logger.logAtLevel
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

function warn (varargin)
    % LOG.WARN - Log a warning message
    % This function provides a convenient interface for logging messages
    % at the Warning level without requiring explicit logger access.
    
    % Forward all arguments to the logAtLevel method of the current logger
    % The varargin cell array contains:
    % - Message text or format string
    % - Optional format arguments for sprintf
    % - Optional name-value pairs (e.g., 'Source', value)
	logAtLevel(log.logger.Current, log.level.Warning, varargin{:});
end