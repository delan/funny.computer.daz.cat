#!/bin/sh
set -eu
rsync -a build/ production.new/
mv production production.old
mv production.new production
rm -R production.old
echo ok
