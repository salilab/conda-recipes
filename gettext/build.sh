#!/bin/bash

./configure --prefix="${PREFIX}" \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --disable-debug \
    --with-included-gettext \
    --with-included-glib \
    --with-included-libcroco \
    --with-included-libunistring \
    --disable-java \
    --disable-csharp \
    --without-git \
    --without-cvs \
    --without-xz \

make
make install
