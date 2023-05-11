#!/bin/sh
set -eu
. ./pages.inc.sh

for i; do
    colordiff -u -- "$i.html" "$i.out.html" || :
done

echo ok
