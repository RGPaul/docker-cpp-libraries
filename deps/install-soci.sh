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

# ----------------------------------------------------------------------------------------------------------------------
# settings

declare SOCI_VERSION=3.2.3

# ----------------------------------------------------------------------------------------------------------------------
# globals

declare CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare SOCI_TARBALL="soci-${SOCI_VERSION}.tar.gz"
declare SOCI_DOWNLOAD_URI="https://github.com/SOCI/soci/archive/${SOCI_VERSION}.tar.gz"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${SOCI_TARBALL} ]; then
        echo "Downloading ${SOCI_TARBALL}"
        curl -L -o ${SOCI_TARBALL} ${SOCI_DOWNLOAD_URI}
    else
        echo "${SOCI_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${SOCI_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${SOCI_TARBALL}\"..."

    tar -xvzf "${SOCI_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # cmake / build / install
    cd soci-${SOCI_VERSION}
    cd build
    cmake -DSOCI_SHARED=OFF -DSOCI_STATIC=ON -DSOCI_TESTS=OFF ../src
    make
    make install

    cp lib/*.a /usr/local/lib

    rm /usr/local/lib64/libsoci_*.a || true

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/soci-${SOCI_VERSION}"
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                              INSTALLING SOCI                             ###\n"
echo "################################################################################\n"


download
unpack
build
cleanup
