#!/bin/sh
set -eu -- \
    bucket \
;

for i; do
    > "site/$i/index.in" printf '<h1 class=title>/%s/</h1>\n' "$i"
    >> "site/$i/index.in" printf '<table rules=cols cellpadding=4>\n'
    >> "site/$i/index.in" printf '<tr><td>d<td>-<td><a href="..">.. (parent directory)</a>\n'
    ls -l -- "$i" | sed -Ef autoindex.sed >> "site/$i/index.in"
    >> "site/$i/index.in" printf '</table>\n'
done

echo ok
