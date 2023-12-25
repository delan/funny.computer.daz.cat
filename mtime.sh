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

result() {
    iso8601 "$1" | tr -d \\n
}

# If the file is dirty or unknown to git, use the file mtime only,
# because any dates in git may be wrong.
if [ -n "$(git status -z -- "$1" | tr \\0 \\n)" ]; then
    result $(mtime "$1")
    exit
fi

# Otherwise, use the git author or commit date, whichever is newer,
# but ignore the file mtime because it may be wrong.
author_date=$(git log -n1 --pretty=format:\%at -- "$1")
commit_date=$(git log -n1 --pretty=format:\%ct -- "$1")
author_date=${author_date:-0}
commit_date=${commit_date:-0}
if [ $author_date -gt $commit_date ]; then
    result $author_date
else
    result $commit_date
fi
