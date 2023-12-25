#!/bin/sh
set -eu
. ./pages.inc.sh

if [ "$(stat -c \%n /dev/null 2> /dev/null)" = /dev/null ] \
&& [ "$(date -ud \@0 +\%FT\%RZ 2> /dev/null)" = 1970-01-01T00:00Z ]; then
    # gnu stat(1) + date(1)
    mtime() {
        date -ud \@$(stat -c \%Y -- "$1") +\%FT\%RZ
    }
elif [ "$(stat -f \%N /dev/null 2> /dev/null)" = /dev/null ] \
&& [ "$(date -ujr 0 +\%FT\%RZ 2> /dev/null)" = 1970-01-01T00:00Z ]; then
    # bsd stat(1) + date(1)
    mtime() {
        date -ujr $(stat -f \%m -- "$1") +\%FT\%RZ
    }
else
    >&2 echo 'fatal: no compatible stat(1) + date(1)'
    exit 1
fi

for i; do
    # works with openbsd ripgrep, which has no --pcre2
    title=$(< "$i.in.html" rg -o '<!-- \[title = .+\] -->' | sed -E 's/<!-- \[title = |\] -->$//g')

    mtime=$(mtime "$i.in.html")

    sed '
        s/<!-- \[edit warning\] -->/<!-- WARNING: you probably want to edit the .in.html, not this file! -->/
        s/<!-- \[title\] -->/'"$title"'/
    ' header.inc.html > "$i.out.html"
    cat "$i.in.html" >> "$i.out.html"
    sed 's/<!-- \[mtime\] -->/'"$mtime"'/' footer.inc.html >> "$i.out.html"
    colordiff -u -- "$i.html" "$i.out.html" || :
done

echo ok
