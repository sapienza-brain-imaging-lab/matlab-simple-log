%MESSAGE Log message class
%   LOG.MESSAGE represents a single log message with associated metadata.
%   This class encapsulates all information needed for a complete log entry
%   including source identification, timestamp, severity level, and message text.
%
%   The class provides methods for logging, formatting, displaying, and
%   saving log messages. Messages can be created with sprintf-style
%   formatting and customized with source and level information.
%
%   Properties:
%   - Source: Origin component or system that generated the message
%   - Timestamp: When the message was created (datetime)
%   - Level: Severity level (Debug, Info, Warning, Error)
%   - Message: The actual formatted message text
%
%   Key Features:
%   - Automatic timestamp generation
%   - sprintf-style message formatting
%   - Integration with logger system
%   - Flexible display and export options
%   - Immutable properties for data integrity
%
%   Examples:
%       % Basic message creation
%       msg = log.message("Operation completed");
%       
%       % Message with formatting
%       msg = log.message("Processed %d items in %0.2f seconds", count, elapsed);
%       
%       % Message with metadata
%       msg = log.message("User authenticated", Source="AuthModule", Level=log.level.Info);
%       
%       % Send to logger
%       msg.log();
%
%   See also: log.logger, log.level, datetime, sprintf
%
%   Author: [Author Name]
%   Date: [Creation Date]
%   Version: 1.0

classdef message
    % LOG.MESSAGE - Log message class with metadata and formatting
    % This class represents a complete log entry with all associated
    % metadata and provides methods for processing and displaying the message.
    
    properties (GetAccess = public, SetAccess = immutable)
        % Source: Component or system that generated this message
        % Type: string (scalar)
        % Access: Public read-only, set only during construction
        % Used for categorizing and filtering messages by origin
        Source(1,1)     string
        
        % Timestamp: When this message was created
        % Type: datetime (scalar)
        % Access: Public read-only, set only during construction
        % Automatically set during message creation for chronological ordering
        Timestamp(1,1)  datetime
        
        % Level: Severity level of this message
        % Type: log.level (scalar)
        % Access: Public read-only, set only during construction
        % Determines message priority and filtering behavior
        Level(1,1)      log.level = log.level.Information
        
        % Message: The formatted message text
        % Type: string (scalar)
        % Access: Public read-only, set only during construction
        % Contains the final formatted message after sprintf processing
        Message(1,1)    string
    end

    methods
        function this = message(message, args, options)
            % MESSAGE Constructor for log message
            % Creates a new log message with optional formatting and metadata
            %
            % Input Arguments:
            %   message - Message text or sprintf format string
            %   args... - Optional arguments for sprintf formatting
            %   options - Name-value pairs for Source and Level
            %
            % The constructor applies sprintf formatting to the message text
            % and sets the timestamp to the current time automatically.
            
            arguments
                % Message text or format string for sprintf
                message(1,1) string
            end

            arguments (Repeating)
                % Optional format arguments for sprintf
                % Can be any data type supported by sprintf
                args
            end

            arguments
                % Named arguments for message metadata
                % Source: Component or system identifier
                % Level: Message severity level
                options.Source(1,1) string = ""
                options.Level(1,1)  log.level = log.level.Information
            end

            % Set message metadata from options
            this.Source = options.Source;
            this.Level = options.Level;
            
            % Set timestamp to current time for chronological ordering
            this.Timestamp = datetime;
            
            % Apply sprintf formatting to create final message text
            % This allows for flexible message construction with variable substitution
            this.Message = sprintf(message, args{:});
        end

        function log(this)
            % LOG Send message to current logger
            % Forwards this message to the current logger instance for processing
            % Handles both scalar messages and arrays of messages
            %
            % This method provides a convenient way to send pre-constructed
            % messages to the logging system without explicitly accessing
            % the logger instance.
            
            % Get current logger instance
            logger = log.logger.Current;
            
            % Process each message in the array
            % This allows batch processing of multiple messages
            for i=1:length(this)
                logger.log(this(i));
            end
        end

        function str = string(this, arg)
            % STRING Convert message to formatted string
            % Converts the message to a formatted string representation
            % using the specified or current logger's formatting rules
            %
            % Input Arguments:
            %   arg.Logger - Optional logger instance for formatting
            %
            % Returns:
            %   str - Formatted string representation of the message
            
            arguments
                % Message(s) to format
                this        log.message
                % Optional logger for custom formatting
                arg.Logger  log.logger {mustBeScalarOrEmpty} = log.logger.empty
            end

            % Use current logger if none specified
            if isempty(arg.Logger)
                arg.Logger = log.logger.Current;
            end
            
            % Delegate to logger's string formatting method
            % This ensures consistent formatting across the logging system
            str = string(arg.Logger, this);
        end

        function print(this, arg)
            % PRINT Display message using logger formatting
            % Displays the message(s) to the console using the logger's
            % formatting rules and display methods
            %
            % Input Arguments:
            %   arg.Logger - Optional logger instance for formatting
            %
            % This method provides formatted console output consistent
            % with the logger's display style and configuration.
            
            arguments
                % Message(s) to display (can be array)
                this(1,:)   log.message
                % Optional logger for custom formatting
                arg.Logger  log.logger {mustBeScalarOrEmpty} = log.logger.empty
            end

            % Use current logger if none specified
            if isempty(arg.Logger)
                arg.Logger = log.logger.Current;
            end
            
            % Delegate to logger's print method
            % This ensures consistent console output formatting
            print(arg.Logger, this);
        end

        function save(this, fileName, arg)
            % SAVE Write messages to file
            % Saves the formatted message(s) to a text file using the
            % logger's formatting rules
            %
            % Input Arguments:
            %   fileName - Output file name or path
            %   arg.Logger - Optional logger instance for formatting
            %
            % The messages are formatted using the logger's string method
            % and written to the file one per line.
            
            arguments
                % Message(s) to save (can be array)
                this(1,:)       log.message
                % Output file name or path
                fileName(1,1)   string
                % Optional logger for custom formatting
                arg.Logger      log.logger {mustBeScalarOrEmpty} = log.logger.empty
            end

            % Use current logger if none specified
            % Note: Fixed typo in original code (arg.logger -> arg.Logger)
            if isempty(arg.Logger)
                arg.Logger = log.logger.Current;
            end
            
            % Format messages using logger's string method
            % This ensures file output matches other logging formats
            str = string(arg.Logger, this);
            
            % Write formatted strings to file
            % Open file in text write mode, write each string on new line
            fid = fopen(fileName, 'wt');
            fprintf(fid, '%s\n', str);
            fclose(fid);
        end
    end
end