#!/bin/sh
set -eu

if [ "$(stat -c \%n /dev/null 2> /dev/null)" = /dev/null ] \
&& [ "$(date -ud \@0 +\%FT\%RZ 2> /dev/null)" = 1970-01-01T00:00Z ]; then
    # gnu stat(1) + date(1)
    mtime() {
        stat -c \%Y -- "$1"
    }
    iso8601() {
        date -ud \@$1 +\%FT\%RZ
    }
elif [ "$(stat -f \%N /dev/null 2> /dev/null)" = /dev/null ] \
&& [ "$(date -ujr 0 +\%FT\%RZ 2> /dev/null)" = 1970-01-01T00:00Z ]; then
    # bsd stat(1) + date(1)
    mtime() {
        stat -f \%m -- "$1"
    }
    iso8601() {
        date -ujr $1 +\%FT\%RZ
    }
else
    >&2 echo 'fatal: no compatible stat(1) + date(1)'
    exit 1
fi

mtime=$(mtime "$1")
author_date=$(git log -n1 --pretty=format:\%at -- "$1")
commit_date=$(git log -n1 --pretty=format:\%ct -- "$1")

mtime=${mtime:-0}
author_date=${author_date:-0}
commit_date=${commit_date:-0}

>&2 echo "mtime is $mtime"
if [ $author_date -gt $mtime ]; then
    >&2 echo "git author date is newer! $author_date"
    mtime=$author_date
fi
if [ $commit_date -gt $mtime ]; then
    >&2 echo "git commit date is newer! $commit_date"
    mtime=$commit_date
fi

iso8601 $mtime | tr -d \\n
