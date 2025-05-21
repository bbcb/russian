#!/bin/sh

NAME=bbcb2-ru
VERSION=2.19
HOMEPAGE=https://github.com/bbcb/russian
MAINTAINER_1="Ivan Denisov <d.ivan.krsk@gmail.com>"

SIZE=$(du -a . | tail -n 1 | awk '{print $1}')

TMP=./bbcb2-ru-deb/
BBCB=$TMP$NAME-$VERSION
DEBIAN=$BBCB/DEBIAN
DOC=$BBCB/usr/share/doc/$NAME
BLACKBOX=/usr/lib/blackbox2

makedeb() {
    cp -r */ $BBCB$BLACKBOX/
    CURD="$(pwd)"
    cd $BBCB
    find . -type f -exec chmod 644 {} ';'
    find . -type d -exec chmod 755 {} ';'
    md5deep -rl usr > DEBIAN/md5sums
    chmod 644 DEBIAN/md5sums
    cd ..
    fakeroot dpkg-deb -Zxz --build *
    cd $CURD
    echo Built $BBCB.deb
    lintian $BBCB.deb
}


rm -fr $TMP
mkdir -p $BBCB$BLACKBOX $DEBIAN $DOC

cat > $DEBIAN/control << EOF
Source: $NAME
Section: devel
Maintainer: ${MAINTAINER_1}
Homepage: ${HOMEPAGE}
Package: ${NAME}
Version: ${VERSION}
Priority: optional
Installed-Size: ${SIZE}
Architecture: all
Depends: bbcb2|bbcb2:i386
Description: Пакет русификации для BlackBox Component Builder 2.0
 Русификация меню и документации интегрированной среды программирования
 .
 для Компонентного Паскаля
EOF

gzip -9cn - > $DOC/changelog.gz << EOF
 -- ${MAINTAINER_1} Wed, 21 May 2025 02:00:00 +0700

 bbcb2-ru (2.19) unstable; urgency=low
  * add Paket

 -- ${MAINTAINER_1} Sat, 10 May 2025 02:00:00 +0700

 bbcb2-ru (2.18) unstable; urgency=low
  * translate DevCPT messages

 -- ${MAINTAINER_1} Sat, 05 Apr 2025 02:00:00 +0700

 bbcb2-ru (2.16) unstable; urgency=low
  * def color for text

 -- ${MAINTAINER_1} Sun, 07 Apr 2023 02:00:00 +0700

 bbcb2-ru (2.15) unstable; urgency=low
  * scale factor

 -- ${MAINTAINER_1} Sat, 06 Apr 2023 02:00:00 +0700

 bbcb2-ru (2.14) unstable; urgency=low
  * checkbox in Help
  * Language Report fixed

 -- ${MAINTAINER_1} Wed, 20 Sep 2023 05:00:00 +0700

 bbcb2-ru (2.13) unstable; urgency=low
  * fix size of Help document

 -- ${MAINTAINER_1} Tue, 28 May 2023 02:00:00 +0700

 bbcb2-ru (2.12) unstable; urgency=low
  * new settings in preferences

 -- ${MAINTAINER_1} Tue, 28 May 2023 02:00:00 +0700

 bbcb2-ru (2.10) unstable; urgency=low
  * design of Help window fixed

 -- ${MAINTAINER_1} Tue, 09 May 2023 14:00:00 +0700

 bbcb2-ru (2.9) unstable; urgency=low
  * Parent folder, Trap, and figures for Tut-2

 -- ${MAINTAINER_1} Mon, 08 May 2023 18:00:00 +0700

 bbcb2-ru (2.0) unstable; urgency=low

  * Initial package

 -- ${MAINTAINER_1} Sat, 25 Jan 2022 13:00:00 +0700
EOF

cat > $DOC/copyright << EOF
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: ${NAME}
Source: ${HOMEPAGE}

Files: *
Copyright: 2018-2025 Authors (Docu/ru/BB-Translators.odc)
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
