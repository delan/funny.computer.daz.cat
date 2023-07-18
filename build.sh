#!/bin/sh
set -eu
. ./pages.inc.sh

for i; do
    # works with openbsd ripgrep, which has no --pcre2
    title=$(< "$i.in.html" rg -o '<!-- \[title = .+\] -->' | sed -E 's/<!-- \[title = |\] -->$//g')

    # only works with bsd stat(1), not gnu stat(1)
    mtime=$(TZ= stat -f '%Sm' -t '%FT%RZ' -- "$i.in.html")

    sed '
        s/<!-- \[edit warning\] -->/<!-- WARNING: you probably want to edit the .in.html, not this file! -->/
        s/<!-- \[title\] -->/'"$title"'/
    ' header.inc.html > "$i.out.html"
    cat "$i.in.html" >> "$i.out.html"
    sed 's/<!-- \[mtime\] -->/'"$mtime"'/' footer.inc.html >> "$i.out.html"
    colordiff -u -- "$i.html" "$i.out.html" || :
done

echo ok
