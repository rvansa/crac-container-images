#!/bin/bash

set -o pipefail

if !(echo "$@" | grep -e '-XX:CRaCRestoreFrom\|restore.sh' > /dev/null) || [ -n "$CHECKPOINT" ]; then
    # This is the run that's going to be checkpointed

    # This makes sure that the new process is started with high enough PID
    # - otherwise a restore without --privileged wouldn't succeed
    if ! echo ${MIN_PID:-1000} | tee /proc/sys/kernel/ns_last_pid > /dev/null 2>&1 ; then
        echo "WARNING: This container is unprivileged, cannot perform checkpoint. Use docker run --privileged ..." >&2
    fi

    if echo "$@" | grep -e "-XX:CRaCCheckpointTo" > /dev/null; then
        IMAGEDIR=$(echo "$@" | sed -n 's/.*-XX:CRaCCheckpointTo=\([^ \t]*\).*/\1/p')
        if ! mount | grep -e " on $IMAGEDIR " > /dev/null; then
            echo "WARNING: Image directory $IMAGEDIR does not seem to be bound outside container. Have you forgot -v /path/to/cr:$IMAGEDIR ?" >&2
        fi

	if [ "$1" = "/bin/sh" -a "$2" = "-c" ]; then
            echo "It appears that CMD has a shell-form rather than exec-form. This could result in this container exiting before the image directory is fully written." >&2
            echo "For more information about shell-form vs. exec-form please see https://docs.docker.com/engine/reference/builder/#cmd" >&2
	    exit 1
        fi
    fi
fi

# We execute right into the process as staying in shell script would cause trouble with propagating signals
exec "$@"
