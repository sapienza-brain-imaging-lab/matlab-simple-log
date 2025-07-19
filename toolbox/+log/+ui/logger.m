% Concrete implementation of a log viewer UI component that connects to a logger
% This class extends the abstract log.ui.component to provide a live view of 
% messages from a specific logger instance, automatically updating as new messages arrive
classdef logger < log.ui.component
	
	% Public properties for configuring the logger connection
	properties (Access = public, AbortSet, SetObservable)
		% The logger instance to monitor for messages
		% Defaults to the current/default logger in the system
		Logger(1,1)		log.logger = log.logger.Current
	end
	
	% Private internal properties for managing the logger connection
	properties (Access = private, Transient, NonCopyable)
		% Previously connected logger (used to detect changes)
		prLogger		log.logger
		% Event listener for receiving messages from the logger
		listener		event.listener
	end

	% Protected methods for component lifecycle management
	methods (Access = protected)
		% Initial setup of the logger component
		function setup (this)
			% Initialize with the current default logger
			this.Logger = log.logger.Current;
			% Call parent class setup to create the UI components
			setup@log.ui.component(this);
		end

		% Update component when properties change
		function update (this)
			% Check if the Logger property has changed
			if ~isequal(this.Logger, this.prLogger)
				% Update the internal reference to the new logger
				this.prLogger = this.Logger;
				
				% Create new event listener for the MessageReceived event
				% This will automatically call addMessage when new messages arrive
				this.listener = event.listener(this.Logger, 'MessageReceived', @this.addMessage);
				
				% Clear existing messages since we're switching to a new logger
				clear(this);
			end
			
			% Call parent class update to handle UI property changes
			update@log.ui.component(this);
		end
	end
	
	% Private helper methods
	methods (Access = private)
		% Callback function for handling new messages from the logger
		function addMessage (this, ~, evt)
			% Extract the message from the event data and add it to the display
			% The add() method is inherited from the parent log.ui.component class
			add(this, evt.Message);
		end
	end
end