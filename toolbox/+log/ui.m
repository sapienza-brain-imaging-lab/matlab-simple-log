%UI Create a live log viewer user interface
%   LOG.UI creates a graphical user interface for viewing log messages
%   in real-time. This function provides a convenient way to launch a
%   log viewer window that displays messages from the logging system.
%
%   LOG.UI() creates a log viewer using the current default logger.
%   The viewer will display all messages sent to the current logger
%   instance and update in real-time as new messages arrive.
%
%   LOG.UI(logger) creates a log viewer for the specified logger instance.
%   This allows monitoring of specific logger instances rather than the
%   default system logger.
%
%   Returns:
%   - panel: log.ui.logger component that can be used to control the viewer
%
%   The log viewer provides:
%   - Real-time display of log messages
%   - Filtering by log level (Debug, Info, Warning, Error)
%   - Sortable columns for timestamp, source, level, and message
%   - Message selection and detailed viewing
%   - Clear functionality to remove old messages
%
%   Examples:
%       % Create viewer for current logger
%       viewer = log.ui();
%       
%       % Create viewer for specific logger
%       myLogger = log.logger();
%       viewer = log.ui(myLogger);
%
%   The viewer automatically updates when new messages are logged and
%   provides an intuitive interface for monitoring application logging.
%
%   See also: log.logger, log.ui.logger, log.ui.component, uifigure
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

function panel = ui (logger)
    % LOG.UI - Create a live log viewer user interface
    % This function creates a graphical interface for viewing and monitoring
    % log messages in real-time with filtering and interaction capabilities.
    
	arguments
        % Optional logger instance to monitor
        % If empty, uses the current default logger
        % Must be scalar log.logger or empty
		logger	log.logger {mustBeScalarOrEmpty} = log.logger.empty
	end

    % Use current logger if none specified
    % This provides a convenient default behavior for most use cases
	if isempty(logger)
		logger = log.logger.Current;
	end
    
    % Create the main figure window for the log viewer
    % The figure is titled "Live Log" to indicate real-time functionality
	fig = uifigure(Name="Live Log");
    
    % Create a grid layout to manage the figure contents
    % Single cell grid that fills the entire figure
	grid = uigridlayout(fig, [1, 1]);
    
    % Create the log viewer component within the grid
    % Pass the logger instance to monitor specific logger
    % The Logger property can be changed later to switch monitoring targets
	panel = log.ui.logger(grid, Logger=logger);
end