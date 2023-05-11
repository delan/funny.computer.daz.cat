#!/bin/sh
set -eu -- \
    bucket \
;

for i; do
    mtime=$(TZ= stat -f '%Sm' -t '%FT%RZ' -- "$i")
    > "$i/index.html" sed 's/<!-- \[title\] -->/\/'"$i"'\/ | /' header.inc.html
    >> "$i/index.html" printf '<h1>/%s/</h1>\n' "$i"
    >> "$i/index.html" printf '<table rules=cols cellpadding=4>\n'
    >> "$i/index.html" printf '<tr><td>d<td>-<td><a href="..">.. (parent directory)</a>\n'
    ls -l -- "$i" | sed -Ef autoindex.sed >> "$i/index.html"
    >> "$i/index.html" printf '</table>\n'
    >> "$i/index.html" sed 's/<!-- \[mtime\] -->/'"$mtime"'/' footer.inc.html
done

echo ok
