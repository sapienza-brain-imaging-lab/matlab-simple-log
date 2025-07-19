% Core logger class for handling log messages with filtering, formatting, and output
% This class provides a complete logging system with configurable levels, console output,
% and event notifications for integration with UI components or other listeners
classdef logger < handle
	
	% Public configuration properties
	properties (Access = public)
		% Minimum log level to process (filters out lower-level messages)
		Level(1,1)			log.level = log.level.Information
		% Whether to display messages to the console/command window
		ConsoleOutput(1,1)	logical = true
		% Whether to notify listeners for all messages (true) or only filtered ones (false)
		NotifyAll(1,1)		logical = true
	end

	% Events that this logger can fire for external listeners
	events (ListenAccess = public, NotifyAccess = private)
		% Fired when a message is received and processed
		% Listeners can subscribe to this event to receive log messages
		MessageReceived
	end

	% Static methods for managing the default/current logger instance
	methods (Access = public, Static)
		% Get the current default logger instance
		% Returns the singleton logger used throughout the application
		function this = Current
			this = defaultLogger();
		end

		% Set a new default logger instance
		% This becomes the system-wide logger accessible via Current()
		function setCurrent (this)
			arguments
				this(1,1)	log.logger
			end

			defaultLogger(this);
		end
	end

	% Public sealed methods for core logging functionality
	methods (Access = public, Sealed)
		% Main logging method that processes a log message
		function log (this, message)
			arguments
				this(1,1)		log.logger
				message(1,1)	log.message
			end

			% Apply level-based filtering
			filtered = filter(this, message);
			
			% Allow subclasses to perform custom processing
			process(this, message, filtered);
			
			% Output to console if enabled and message passes filter
			if filtered
				if this.ConsoleOutput
					print(this, message);
				end
			end
			
			% Notify listeners based on NotifyAll setting:
			% - If NotifyAll is true: notify for all messages
			% - If NotifyAll is false: notify only for filtered messages
			if filtered || this.NotifyAll
				notify(this, 'MessageReceived', log.event(message));
			end
		end
	end

	% Hidden utility methods for internal use and convenience
	methods (Access = public, Sealed, Hidden)
		% Convenience method to log a message at a specific level
		% Handles message creation with formatting and optional source
		function logAtLevel (this, level, message, args, options)
			arguments
				this(1,1)		log.logger
				level(1,1)		log.level
				message(1,1)	string
			end

            arguments (Repeating)
				args  % Additional arguments for string formatting (like sprintf)
            end

            arguments
				options.Source(1,1)	string = ""  % Optional source identifier
			end

			% Convert options to cell array and create log message
			options = namedargs2cell(options);
			message = log.message(message, args{:}, options{:}, Level=level);
			log(this, message);
		end

		% Convert log messages to formatted strings
		% Returns an array of formatted strings for display purposes
		function str = string (this, message)
			arguments
				this(1,1)		log.logger
				message(:,1)	log.message
			end

			% Process each message individually
			str = strings(size(message));
			for i=1:numel(message)
				str(i) = formatString(this, message(i));
			end			
		end

		% Print messages to the console
		% Displays formatted messages using MATLAB's disp function
		function print (this, message)
			arguments
				this(1,1)		log.logger
				message(:,1)	log.message
			end

			% Display each message on a separate line
			for i=1:numel(message)
				disp(formatString(this, message(i)));
			end
		end
	end

	% Protected methods that can be overridden by subclasses
	methods (Access = protected)
		% Filter messages based on log level
		% Returns true if message should be processed, false otherwise
		function flag = filter (this, message)
			flag = message.Level >= this.Level;
		end

		% Format a log message as a string for display
		% Creates a standardized format: | Source | Timestamp | Level | Message |
		function str = formatString (~, message)
			str = sprintf('| %-12s | %s | %-11s | %s', ...
				message.Source, message.Timestamp, message.Level, message.Message);
		end

		% Hook for subclasses to perform custom processing
		% Called for every message regardless of filtering
		% Parameters: message (the log message), filtered (whether it passed the filter)
		function process (~, ~, ~)
			% Default implementation does nothing
			% Subclasses can override this to add custom behavior
		end
	end
end

% Persistent function to manage the default logger singleton
% This ensures there's always a system-wide logger available
function out = defaultLogger (in)
	persistent currentLogger  % Maintains state between function calls
	
	if nargin
		% Set mode: store the provided logger as the default
		currentLogger = in;
	elseif isempty(currentLogger)
		% Initialize mode: create a new logger if none exists
		currentLogger = log.logger;
	end
	
	% Return the current default logger
	out = currentLogger;
end