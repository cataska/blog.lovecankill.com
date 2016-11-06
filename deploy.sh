#!/bin/sh
set -e

: ${upstream:=origin}
: ${REPO:=https://github.com/cataska/cataska.github.io.git}

git fetch $upstream
if [ `git rev-list HEAD...$upstream/master --count` -ne 0 ]; then
  echo "not deploying"
  exit 1
fi

rm -fr _public
git clone $REPO _public

REV=`git describe --always`
cd _public
rm -fr *

cp ../CNAME .

cp -R ../resources/public/* .
git add -A .
git commit -m "regen for $REV"

git push origin master
