#!/bin/sh
set -eu
. ./pages.inc.sh

for i; do
    title=$(rg -o --pcre2 '(?<=<!-- \[title = ).+(?=] -->)' -- "$i.in.html" || :)
    mtime=$(TZ= stat -f '%Sm' -t '%FT%RZ' -- "$i.in.html")
    sed 's/<!-- \[title\] -->/'"$title"'/' header.inc.html > "$i.out.html"
    cat "$i.in.html" >> "$i.out.html"
    sed 's/<!-- \[mtime\] -->/'"$mtime"'/' footer.inc.html >> "$i.out.html"
    colordiff -u -- "$i.html" "$i.out.html" || :
done

echo ok
