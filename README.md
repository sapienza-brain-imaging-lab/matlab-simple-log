# Simple Log Toolbox

A simple, comprehensive and flexible logging system for MATLAB applications that provides structured logging with multiple severity levels, real-time UI monitoring, and event-driven architecture.

## Features

- **Hierarchical log levels**: Debug, Information, Warning, and Error levels with automatic filtering
- **Flexible message formatting**: sprintf-style formatting with metadata support
- **Real-time UI viewer**: Live log monitoring with filtering and search capabilities
- **Event-driven architecture**: Subscribe to log events for custom processing
- **Singleton pattern**: Global logger access with support for multiple independent loggers
- **File export**: Save log messages to files with consistent formatting
- **Console output control**: Enable/disable console output as needed
- **Source tracking**: Identify message origins for better debugging
- **Completely customizable**: Create your own logger providing a custom message formatting or sending logs to external services
- **Customizable UI**: Abstract log monitor UI component ready to be customized

## Quick Start

### Basic Usage

```matlab
% Simple logging
log.info('Application started');
log.warn('Configuration file not found, using defaults');
log.error('Failed to connect to database');

% Formatted messages
log.info('Processing %d items', itemCount);
log.debug('User %s logged in from %s', username, ipAddress);
```

### Log levels

The toolbox provides four hierarchical log levels:

- **Debug (0)**: Detailed debugging information (step-by-step execution, variable dumps, detailed diagnostics)
- **Information (1)**: General informational messages (normal operation confirmations, progress updates)
- **Warning (2)**: Warning messages for non-critical issues (recoverable errors, deprecated features, configuration issues)
- **Error (3)**: Error messages for critical problems (critical failures, validation errors, unrecoverable problems)

### Setting log level

```matlab
% Get current logger
logger = log.logger.Current;

% Set to Debug level (shows all messages)
logger.Level = log.level.Debug;

% Set to Error level (shows only errors)
logger.Level = log.level.Error;
```

### Live Log Viewer

```matlab
% Open live log viewer
viewer = log.ui();

% Now all log messages will appear in the viewer in real-time
log.info('This message will appear in the viewer');
log.error('This error will also appear');
```

## Core components

### Default logger class

The `log.logger` class is the core component that processes messages:

```matlab
% Get the default logger instance
myLogger = log.logger.Current;

% Configure logger properties
myLogger.Level = log.level.Debug;
myLogger.ConsoleOutput = false;  % Disable console output
myLogger.NotifyAll = true;       % Send events for all messages
```

### Custom loggers

You can subclass `log.logger` to create your own logger:

```matlab
% Create a new logger instance
myLogger = MyOwnCustomLogger();

% Set as current logger
log.logger.setCurrent(myLogger);
```

### Message class

The `log.message` class represents individual log entries:

```matlab
% Create message with metadata
msg = log.message("Operation completed", ...
    Source="DataProcessor", ...
    Level=log.level.Information);

% Send to logger
msg.log();

% Or send to specific logger
myLogger.log(msg);
```

## Advanced usage

### Custom source identification

```matlab
% Specify source for better traceability
log.info('User authenticated', Source='AuthModule');
log.error('Database connection failed', Source='DatabaseManager');
```

### Assertions with logging

```matlab
% Assert with automatic logging
log.assert(x > 0, 'Value must be positive');

% Assert without throwing error (useful for testing)
log.assert(isValid, 'Validation failed', ThrowError=false);
```

### Error handling

```matlab
% Log error and throw exception
log.error('Critical failure occurred');

% Log error without throwing exception
log.error('Non-critical error', ThrowError=false);
```

### Event listening

```matlab
% Listen to log events
logger = log.logger.Current;
listener = addlistener(logger, 'MessageReceived', @handleLogEvent);

function handleLogEvent(~, eventData)
    msg = eventData.Message;
    if msg.Level == log.level.Error
        % Custom error handling
        sendEmailAlert(msg.Message);
    end
end
```

### File export

```matlab
% Create and save messages
messages = [
    log.message("Process started", Level=log.level.Information);
    log.message("Warning: Low memory", Level=log.level.Warning);
    log.message("Process completed", Level=log.level.Information)
];

% Save to file
messages.save('process_log.txt');
```

## UI components

### Live log viewer

The live log viewer provides real-time monitoring of log messages:

```matlab
% Basic viewer
viewer = log.ui();

% Viewer for specific logger
myLogger = log.logger();
viewer = log.ui(myLogger);
```

The viewer includes:
- Real-time message display
- Log level filtering
- Source and timestamp columns
- Message selection and details
- Clear functionality

### Customizing the viewer

```matlab
% Access the viewer component
viewer = log.ui();

% Customize display options
viewer.ShowSource = false;         % Hide source column
viewer.ShowTime = "none";          % Hide timestamp
viewer.LogLevel = log.level.Error; % Show only errors
viewer.AllowClear = false;         % Disable clear button
```

To integrate a basic log UI into a custom interface, subclass the `logger.ui.component` class.

## Configuration examples

### Development configuration

```matlab
% Verbose logging for development
logger = log.logger.Current;
logger.Level = log.level.Debug;
logger.ConsoleOutput = true;

% Open viewer for monitoring
viewer = log.ui();
```

### Production configuration

```matlab
% Minimal logging for production
logger = log.logger.Current;
logger.Level = log.level.Warning;
logger.ConsoleOutput = false;

% Set up error alerting
addlistener(logger, 'MessageReceived', @productionErrorHandler);
```

## Best practices

### Message formatting

```matlab
% Good: Descriptive messages with context
log.info('User %s successfully logged in from %s', username, clientIP);

% Good: Include relevant data
log.warn('Memory usage at %d%% of available %d MB', percentage, totalMB);

% Avoid: Vague messages
log.info('Something happened');
```

### Source identification

```matlab
% Use consistent source names
log.info('Connection established', Source='DatabaseManager');
log.error('Query failed', Source='DatabaseManager');

% Group related functionality
log.debug('Parsing configuration file', Source='ConfigLoader');
log.warn('Invalid setting ignored', Source='ConfigLoader');
```

## Integration with existing code

### Gradual Migration

```matlab
% Replace existing fprintf statements
% Old:
fprintf('Processing item %d of %d\n', i, total);

% New:
log.info('Processing item %d of %d', i, total);
```

### Wrapper functions

```matlab
function loggedFunction()
    log.info('Starting loggedFunction', 'Source', 'MyModule');
    try
        % Function implementation
        result = complexOperation();
        log.info('Operation completed successfully', 'Source', 'MyModule');
    catch err
        log.error('Operation failed: %s', err.message, 'Source', 'MyModule');
        rethrow(err);
    end
end
```

## Troubleshooting

### Common issues

1. **Messages not appearing**: Check logger level setting
2. **Too many messages**: Increase log level to reduce verbosity
3. **UI not updating**: Ensure logger instance matches viewer logger
4. **Performance issues**: Avoid expensive operations in debug messages

### Debug mode

```matlab
% Enable maximum verbosity
logger = log.logger.Current;
logger.Level = log.level.Debug;
logger.ConsoleOutput = true;

% Check current configuration
fprintf('Current level: %s\n', logger.Level);
fprintf('Console output: %s\n', mat2str(logger.ConsoleOutput));
```

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](toolbox/LICENSE) file for details.