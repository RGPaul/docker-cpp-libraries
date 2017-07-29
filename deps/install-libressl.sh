#!/bin/bash
# ----------------------------------------------------------------------------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2017 Ralph-Gordon Paul. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ----------------------------------------------------------------------------------------------------------------------

set -e

#=======================================================================================================================
# settings

declare LIBRESSL_VERSION=libressl-2.5.4

#=======================================================================================================================
# globals

declare CURRENT_DIR=$(pwd)
declare LIBRESSL_TARBALL="${LIBRESSL_VERSION}.tar.gz"
declare LIBRESSL_DOWNLOAD_URI="https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${LIBRESSL_VERSION}.tar.gz"
declare LIBRESSL_INSTALL_FOLDER="${CURRENT_DIR}/${LIBRESSL_VERSION}"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${LIBRESSL_TARBALL} ]; then
        echo "Downloading ${LIBRESSL_TARBALL}"
        curl -L -o ${LIBRESSL_TARBALL} ${LIBRESSL_DOWNLOAD_URI}
    else
        echo "${LIBRESSL_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${LIBRESSL_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${LIBRESSL_TARBALL}\"..."

    tar -xvzf "${LIBRESSL_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # cmake / build / install
    cd ${LIBRESSL_VERSION}
    cmake -DBUILD_SHARED=OFF .
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/${LIBRESSL_VERSION}"

    # remove shared libs - we only want the static ones
    rm /usr/local/lib/libtls.so /usr/local/lib/libtls.so.* || true
    rm /usr/local/lib/libcrypto.so /usr/local/lib/libcrypto.so.* || true
    rm /usr/local/lib/libssl.so /usr/local/lib/libssl.so.* || true
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                            INSTALLING LibreSSL                           ###\n"
echo "################################################################################\n"


download
unpack
build
cleanup
