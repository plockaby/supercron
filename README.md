# NAME

supercron

# USAGE

    supercron --configuration=/path/to/configuration

# DESCRIPTION

This program functions like cron but will instead start programs controlled by
[supervisor](https://github.com/Supervisor/supervisor). Event precision is 60
seconds meaning that it can only run a program as often as every 60 seconds.
Configuring ```supercron``` is very familiar. In this example, "foo1" will run
every minute, "foo2" will run every five minutes, and "foo3" will run at the
top of every hour:

    * * * * * foo1
    */5 * * * * foo2
    0 * * * * foo3

The only difference is that "foo1", "foo2" and "foo3" are configured program
names in supervisor rather than actual commands. Changes in crontabs are picked
up automatically and do not require a restart.

To get ```supercron``` running you might configure it like this:

    [eventlistener:supercron]
    command = /usr/local/bin/supercron --configuration=/etc/supervisor/supercron.d/%(host_node_name)s/*.crontab
    events = TICK
    buffer_size = 0
    autostart = true
    autorestart = true
    stopsignal = INT
    stdout_logfile = /var/log/supervisor/supercron.log
    stdout_logfile_maxbytes = 10MB
    stdout_logfile_backups = 4
    stderr_logfile = /var/log/supervisor/supercron.err
    stderr_logfile_maxbytes = 10MB
    stderr_logfile_backups = 4

It is very importat that the buffer size be zero. Otherwise, if ```supercron```
is stopped for any reason then ```TICK``` events will queue until
```supercron``` is started again and programs that should have run in the time
that ```supercron``` was not running will all run when ```supercron``` starts
again. So if ```supercron``` is stopped for five minutes and a program is
configured to run every minute then it will be started five times as soon as
```supercron``` starts again. This is not what you want. Turning off the buffer
prevents this behavior.

To configuration of a program to managed by ```supercron``` is slightly
different. Here is an example configuration:

    [program:periodic-prog]
    command = /usr/local/bin/periodic-prog
    process_name = %(program_name)s
    user = nobody
    autostart = false
    autorestart = false
    startsecs = 0
    startretries = 0
    stopsignal = TERM
    stdout_logfile = /var/log/supervisor/periodic-prog.log
    stdout_logfile_maxbytes = 10MB
    stdout_logfile_backups = 4
    stderr_logfile = /var/log/supervisor/periodic-prog.err
    stderr_logfile_maxbytes = 10MB
    stderr_logfile_backups = 4

Note the differences are that this program is not configured to start or
restart automatically. It will only be started by ```supercron``` -- or
manually by an administrator. Additionally, it will not try to start the
program again if it fails to start (```startretries = 0```) and it will not
wait to see if the program continues to run after starting it
(```startsecs = 0```). All other configuration options are identical to a
normal program.

# OPTIONS

- --configuration

    REQUIRED: The full path to the crontab file that will configure
    ```supercron```. If this is a glob then it will load all the crontab files
    that match.

- --debug

    Enable debugging output.

- --help

    Shows this message.

# AUTHOR

Paul Lockaby <paul@paullockaby.com>

# COPYRIGHT

Copyright (c) 2015, 2016 Paul Lockaby, University of Washington. All rights
reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. The full text of this license can be found in
the LICENSE file included with this module.
