#!/bin/bash
# Hue web server
# description: Hue web server

. /etc/init.d/functions

if [ -d "$HUE_HOME" ]; then
	echo "HUE_HOME=$HUE_HOME"
else
	HUE_HOME=$HOME/hue
	echo "HUE_HOME=$HUE_HOME"
fi

DAEMON=$HUE_HOME/build/env/bin/supervisor
LOGDIR=$HUE_HOME/logs
PIDFILE=$HUE_HOME/supervisor.pid
EXEC=$HUE_HOME/build/env/bin/python
DAEMON_OPTS="-p $PIDFILE -l $LOGDIR -d"

start() {
        echo -n "Starting hue: "
        # Check if already running
        if [ -e $PIDFILE ] && checkpid $(cat $PIDFILE) ; then
            echo "already running"
            return
        fi
        $DAEMON $DAEMON_OPTS
        ret=$?
        base=$(basename $0)
        if [ $ret -eq 0 ]; then
            sleep 1
            test -e $PIDFILE && checkpid $(cat $PIDFILE)
            ret=$?
        fi
        if [ $ret -eq 0 ]; then
            success $"$base startup"
        else
            failure $"$base startup"
        fi
        echo
        return $ret
}

stop() {
        echo -n "Shutting down hue: "
        killproc -p $PIDFILE -d 15 $DAEMON
        ret=$?
        echo
        return $ret
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status -p $PIDFILE  supervisor
        ;;
    restart|reload)
        stop
        start
        ;;
    *)
        echo "Usage: hue {start|stop|status|reload|restart"
        exit 1
        ;;
esac
exit $?
