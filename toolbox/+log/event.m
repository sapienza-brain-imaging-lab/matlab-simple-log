%EVENT Log event data class
%   LOG.EVENT extends MATLAB's event.EventData class to provide
%   log-specific event data for the logging system's event notification
%   mechanism. This class is used when logger instances notify listeners
%   about new log messages.
%
%   The event data contains the log message that triggered the event,
%   allowing event handlers to access the full message information
%   including source, timestamp, level, and message text.
%
%   This class is typically used internally by the logging system and
%   is not directly instantiated by users. It is created automatically
%   when the logger fires MessageReceived events.
%
%   Properties:
%   - Message: The log.message instance that triggered the event
%
%   Example Usage (in event handler):
%       function handleLogEvent(~, eventData)
%           msg = eventData.Message;
%           fprintf('Received log: %s\n', msg.Message);
%       end
%
%   See also: log.logger, log.message, event.EventData, event.listener
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

classdef event < event.EventData
    % LOG.EVENT - Event data for log message notifications
    % This class encapsulates log message data for event-driven logging
    % scenarios where external components need to be notified of log events.
    
	properties (GetAccess = public, SetAccess = immutable)
        % Message: The log message that triggered this event
        % Type: log.message (scalar)
        % Access: Public read-only, set only during construction
        % Contains the complete log message with source, timestamp, level, and text
		Message
	end

	methods
		function this = event (message)
            % EVENT Constructor for log event data
            % Creates a new event data object containing the specified log message
            %
            % Input Arguments:
            %   message - log.message instance that triggered the event
            %
            % The constructor validates that the input is a scalar log.message
            % and stores it as immutable event data.
            
			arguments
                % Validate that message is a scalar log.message instance
				message(1,1)	log.message
			end

            % Store the message as immutable property
            % This ensures event data integrity throughout the event lifecycle
			this.Message = message;
		end
	end
end