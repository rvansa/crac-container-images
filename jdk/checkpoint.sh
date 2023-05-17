#!/bin/bash

set -o pipefail

if ! echo 1000 | tee /proc/sys/kernel/ns_last_pid > /dev/null 2>&1 ; then
    echo "This container is unprivileged, cannot perform checkpoint. Use docker run --privileged ..." >&2
    exit 1;
fi

PIDS=$(jps -v | grep -e '-XX:CRaCCheckpointTo=' | cut -f 1 -d ' ')
if [ -z "$PIDS" ]; then
    echo "No processes to checkpoint." >&2
    exit 1;
fi
for PID in $PIDS; do
    IMAGEDIR=$(jps -v | sed -n 's/^'$PID'.*-XX:CRaCCheckpointTo=\([^ \t]*\).*/\1/p')
    if ! mount | grep -e " on $IMAGEDIR " > /dev/null; then
	echo "WARNING: Image directory $IMAGEDIR does not seem to be bound outside container. Have you forgot -v /path/to/cr:$IMAGEDIR ?" >&2
    fi
    jcmd $PID JDK.checkpoint   
done
