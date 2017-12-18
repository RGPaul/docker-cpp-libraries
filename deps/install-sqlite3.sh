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
declare SQLITE_VERSION=3210000

#=======================================================================================================================
# globals
declare CURRENT_DIR=$(pwd)
declare SQLITE_TARBALL="sqlite-autoconf-${SQLITE_VERSION}.tar.gz"
declare SQLITE_FOLDER="${CURRENT_DIR}/sqlite-autoconf-${SQLITE_VERSION}"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${SQLITE_TARBALL} ]; then
        echo "Downloading ${SQLITE_TARBALL}"
        curl -L -o ${SQLITE_TARBALL} "https://www.sqlite.org/2017/${SQLITE_TARBALL}"
    else
        echo "${SQLITE_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${SQLITE_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking into \"${SQLITE_FOLDER}\"..."

    tar -xvzf "${SQLITE_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    cd ${SQLITE_FOLDER}
    ./configure -disable-shared
    make
    make install
    cd ${CURRENT_DIR}
}

#=======================================================================================================================

function cleanup()
{
    echo "cleanup ..."

    rm -rf ${SQLITE_FOLDER}

    # remove shared libs - we only want the static one
    rm /usr/local/lib/libsqlite3.so /usr/local/lib/libsqlite3.so.* || true
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                            INSTALLING SQLite3                            ###\n"
echo "################################################################################\n"


download
unpack
build
cleanup
