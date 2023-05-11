#!/bin/sh
set -eu
. ./pages.inc.sh

for i; do
    cp -- "$i.out.html" "$i.html"
done

echo ok
