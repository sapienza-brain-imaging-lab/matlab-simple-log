% Abstract base class for a log viewer UI component
% This component provides a table-based interface for displaying and managing log messages
% with filtering, selection, and styling capabilities
classdef (Abstract) component < matlab.ui.componentcontainer.ComponentContainer

	% Public properties with automatic notification and validation
	properties (Access = public, AbortSet, SetObservable)
		% Minimum log level to display (filters out lower level messages)
		LogLevel(1,1)	log.level = log.level.Information
	end

	% Dependent properties that compute values based on other properties
	properties (Access = public, AbortSet, SetObservable, Dependent)
		% Controls visibility of the Clear button
		AllowClear(1,1)	matlab.lang.OnOffSwitchState = matlab.lang.OnOffSwitchState.on
	end

	% Additional display configuration properties
	properties (Access = public, AbortSet, SetObservable)
		% Controls visibility of the Source column in the log table
		ShowSource(1,1)	matlab.lang.OnOffSwitchState = matlab.lang.OnOffSwitchState.on
		% Time display format: "none", "compact" (HH:mm:ss), or "full" (yyyy-MM-dd'T'HH:mm:ss)
		ShowTime(1,1)	string {mustBeMember(ShowTime,["none","compact","full"])} = "compact"
	end

	% Read-only dependent property for the currently selected message
	properties (Access = public, Dependent)
		% Currently selected log message (empty if none selected)
		SelectedMessage	log.message {mustBeScalarOrEmpty}
	end

	% Private internal properties for UI components and data management
	properties (Access = private, Transient, NonCopyable)
		levelMenu		matlab.ui.control.DropDown	% Dropdown for selecting log level filter
		clearButton		matlab.ui.control.Button	% Button to clear all log messages
		logTable		matlab.ui.control.Table		% Table displaying log messages
		style			dictionary					% Dictionary mapping log levels to UI styles
		messages(:,1)	log.message					% Array of all log messages
		selectedMessage	log.message					% Currently selected message (internal storage)
		listener		event.listener				% Event listener for external updates
	end

	% Events that this component can notify listeners about
	events (ListenAccess = public, NotifyAccess = private)
		% Fired when a log message is selected or deselected
		MessageSelected
	end

	% Public methods including property getters and setters
	methods
		% Getter for AllowClear property - returns visibility state of clear button
		function flag = get.AllowClear (this)
			flag = this.clearButton.Visible;
		end

		% Setter for AllowClear property - controls clear button visibility
		function set.AllowClear (this, flag)
			this.clearButton.Visible = flag;
		end

		% Getter for SelectedMessage property - returns currently selected message
		function task = get.SelectedMessage (this)
			task = this.selectedMessage;
		end

		% Setter for SelectedMessage property - updates selection and notifies listeners
		function set.SelectedMessage (this, message)
			if isempty(message)
				selectedRow = [];
			else
				% Find the row index of the specified message
				selectedRow = find(message == this.messages, 1);
			end

			if isempty(selectedRow)
				% Clear selection if message not found or empty
				if ~isempty(this.SelectedMessage)
					this.selectedMessage = log.message.empty;
					this.logTable.Selection = [];
					notify(this, 'MessageSelected', log.event(this.selectedMessage));
				end
			else
				% Update table selection and internal state
				this.logTable.Selection = selectedRow;
				if ~isequal(message, this.selectedMessage)
					this.selectedMessage = message;
					notify(this, 'MessageSelected', log.event(this.selectedMessage));
				end
			end
		end
	end

	% Protected methods for component lifecycle management
	methods (Access = protected)
		% Initial setup of the UI components and layout
		function setup (this)
			% Create main grid layout with header row and table row
			grid = uigridlayout(this, ...
				Padding=0, ...
				ColumnWidth={'1x'}, ...
				RowHeight={30,'1x'});

			% Create header grid for controls (label, dropdown, button)
			menuGrid = uigridlayout(grid, ...
				Padding=0, ...
				ColumnWidth={'fit','1x',50}, ...
				RowHeight={'1x'});

			% Add log level label
			uilabel(menuGrid, Text="Log level:");

			% Create dropdown for log level selection
			this.levelMenu = uidropdown(menuGrid, ...
				Items=["Debug","Information","Warning","Error"], ...
				ValueChangedFcn=@this.selectLevel, ...
				Value="Information");

			% Create clear button
			this.clearButton = uibutton(menuGrid, ...
				Text="Clear", ...
				ButtonPushedFcn=@this.clear);

			% Create main log table
			this.logTable = uitable(grid, ...
				SelectionType="row", ...
				SelectionChangedFcn=@this.onMessageSelected, ...
				Multiselect="off", ...
				ColumnRearrangeable=false, ...
				ColumnSortable=false);

			% Initialize style dictionary for different log levels
			this.style = dictionary(...
				log.level.Debug, iconStyle("question"), ...
				log.level.Information, iconStyle("info"), ...
				log.level.Warning, iconStyle("warning"), ...
				log.level.Error, iconStyle("error"));

			% Synchronize background colors across components
			try %#ok<TRYNC>
				ui.util.syncBackgroundColor([this, grid, this.logTable]);
			end
		end

		% Update UI when properties change
		function update (this)
			% Sync dropdown value with LogLevel property
			this.levelMenu.Value = this.LogLevel;
			% Recreate table content to reflect changes
			recreate(this);
		end
	end

	% Protected sealed methods for message management
	methods (Access = protected, Sealed)
		% Add new messages to the log display
		function add (this, messages)
			arguments
				this(1,1)		log.ui.component
				messages(:,1)	log.message
			end

			if isempty(messages), return; end
			% Append to internal message array
			this.messages = [this.messages; messages];
			% Add to table display
			appendMessages(this, messages);
		end

		% Clear all messages from the log display
		function clear (this, ~, ~)
			arguments
				this(1,1)		log.ui.component
				~  % Event source (unused)
				~  % Event data (unused)
			end

			% Clear table data and styling
			this.logTable.Data(:,:) = [];
			removeStyle(this.logTable);
			% Clear internal message array
			this.messages(:) = [];
		end
	end

	% Private helper methods
	methods (Access = private)
		% Recreate the entire table display (used when properties change)
		function recreate (this)
			% Preserve current selection
			selection = this.SelectedMessage;
			% Clear and rebuild table
			this.logTable.Data = table;
			removeStyle(this.logTable);
			appendMessages(this, this.messages);
			% Restore selection
			this.SelectedMessage = selection;
		end

		% Callback for log level dropdown selection
		function selectLevel (this, ~, ~)
			this.LogLevel = this.levelMenu.Value;
		end

		% Callback for table row selection changes
		function onMessageSelected (this, ~, evt)
			if isempty(evt.Selection)
				this.SelectedMessage = log.message.empty;
			else
				this.SelectedMessage = this.messages(evt.Selection);
			end
		end

		% Append messages to the table display with proper formatting and styling
		function appendMessages (this, msg)
			% Filter messages based on current log level
			msg = msg([msg.Level] >= this.LogLevel);

			% Set up column widths (Level, Source, Time, Message)
			width = {30, 'auto', 65, 'auto'};

			if isempty(msg)
				% Create empty table with proper column structure
				data = table(string.empty, string.empty, string.empty, string.empty, VariableNames=["Level","Source","Time","Message"]);
			else
				% Extract message data
				Message = [msg.Message]';

				% Format timestamps based on ShowTime setting
				if this.ShowTime == "full"
					Time = string([msg.Timestamp], "yyyy-MM-dd'T'HH:mm:ss")';
					width{3} = 200;  % Wider column for full timestamp
				else
					Time = string([msg.Timestamp], "HH:mm:ss")';
				end

				Source = [msg.Source]';
				Level = repmat("", length(msg), 1);  % Level column shows icons, not text
				data = table(Level, Source, Time, Message);
			end

			% Remove columns based on display settings
			if this.ShowTime == "none"
				data(:,3) = [];
				width(3) = [];
			end
			if ~this.ShowSource
				data(:,2) = [];
				width(2) = [];
			end

			% Append data to existing table content
			n = height(this.logTable.Data);
			this.logTable.Data = [this.logTable.Data; data];
			this.logTable.ColumnWidth = width;
			this.logTable.ColumnName{1} = '';  % Hide level column header (shows icons)

			% Apply styling (icons) to level column for each new message
			for i=1:height(data)
				addStyle(this.logTable, this.style(msg(i).Level), "cell", [n+i,1]);
			end
		end
	end
end

% Helper function to create icon styles for different log levels
function s = iconStyle (name)
	s = uistyle(Icon=name);
end