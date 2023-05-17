#!/bin/bash

restore() {
    echo "Restoring from $1 ..."
    IMAGEDIR=$1
    shift
    exec /usr/bin/java -XX:CRaCRestoreFrom=$IMAGEDIR "$@"
}

if [ -n "$IMAGEDIR" ]; then
    if [ ! -d "$IMAGEDIR" ]; then
        echo "'$IMAGEDIR' is not a directory, cannot restore." >&2
	exit 1
    elif [ ! -f "$IMAGEDIR/cppath" ]; then
	echo "Directory $IMAGEDIR does not contain file 'cppath', cannot restore." >&2
	exit 1
    fi
    restore $IMAGEDIR "$@"
fi    

CANDIDATES=$(mount | grep /dev/mapper/vgubuntu-root | grep -v -e 'on /etc' | sed -e 's/.* on \(\/[^ ]*\) type.*/\1/')
if [ -z "$CANDIDATES" ]; then
    echo "No volumes mounted for C/R found" >&2
    exit 1;
fi
for DIR in $CANDIDATES; do
    if [ -f $DIR/cppath ]; then
    	restore $DIR "$@"
    fi
done

echo "Did not find 'cppath' in any of the available mounts; cannot restore." >&2
exit 1
