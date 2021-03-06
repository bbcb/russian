#!/bin/sh

NAME=bbcb-ru
VERSION=1.0
HOMEPAGE=https://github.com/bbcb/russian
MAINTAINER_1="Ivan Denisov <d.ivan.krsk@gmail.com>"

SIZE=$(du -a . | tail -n 1 | awk '{print $1}')

TMP=/tmp/bbcb-ru-deb/
BBCB=$TMP$NAME-$VERSION
DEBIAN=$BBCB/DEBIAN
DOC=$BBCB/usr/share/doc/$NAME
BLACKBOX=/usr/lib/blackbox

makedeb() {
    cp -r */ $BBCB$BLACKBOX/
    CURD="$(pwd)"
    cd $BBCB
    find . -type f -exec chmod 644 {} ';'
    find . -type d -exec chmod 755 {} ';'
    md5deep -rl usr > DEBIAN/md5sums
    chmod 644 DEBIAN/md5sums
    cd ..
    fakeroot dpkg-deb --build *
    cd $CURD
    echo Built $BBCB.deb
    lintian $BBCB.deb
}


rm -fr $TMP
mkdir -p $BBCB$BLACKBOX $DEBIAN $DOC

cat > $DEBIAN/control << EOF
Source: bbcb-ru
Section: devel
Maintainer: ${MAINTAINER_1}
Homepage: ${HOMEPAGE}
Package: ${NAME}
Version: ${VERSION}
Priority: optional
Installed-Size: ${SIZE}
Architecture: all
Depends: bbcb|bbcb:i386
Description: Пакет русификации для BlackBox Component Builder
 Русификация меню и документации интегрированной среды программирования
 .
 для Компонентного Паскаля
EOF

gzip -9cn - > $DOC/changelog.gz << EOF
 bbcb-ru (1.0) unstable; urgency=low
  * Initial package

 -- ${MAINTAINER_1} Sun, 03 Jan 2021 00:00:00 +0200
EOF

cat > $DOC/copyright << EOF
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: ${NAME}
Source: ${HOMEPAGE}

Files: *
Copyright: 2018-2021 Ivan A. Denisov <d.ivan.krsk@gmail.com>
License: BSD-2-clause
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 .
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 .
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 .
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

EOF

makedeb
