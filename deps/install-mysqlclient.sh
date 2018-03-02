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

declare MYSQLCLIENT_VERSION=mysql-connector-c-6.1.11

#=======================================================================================================================
# globals

declare CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare MYSQLCLIENT_TARBALL="${MYSQLCLIENT_VERSION}-src.tar.gz"
declare MYSQLCLIENT_DOWNLOAD_URI="https://dev.mysql.com/get/Downloads/Connector-C/${MYSQLCLIENT_VERSION}-src.tar.gz"
declare MYSQLCLIENT_INSTALL_FOLDER="${CURRENT_DIR}/${MYSQLCLIENT_VERSION}"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${MYSQLCLIENT_TARBALL} ]; then
        echo "Downloading ${MYSQLCLIENT_TARBALL}"
        curl -L -o ${MYSQLCLIENT_TARBALL} ${MYSQLCLIENT_DOWNLOAD_URI}
    else
        echo "${MYSQLCLIENT_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${MYSQLCLIENT_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${MYSQLCLIENT_TARBALL}\"..."

    tar -xvzf "${MYSQLCLIENT_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # cmake / build / install
    cd ${MYSQLCLIENT_VERSION}-src
    mkdir build
    cd build
    cmake ..
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/${MYSQLCLIENT_VERSION}-src"
}

#=======================================================================================================================

function copy()
{
    echo "copy results ..."

    # copy new libs
    mv /usr/local/mysql/lib/*.a /usr/local/lib/

    mv /usr/local/mysql/include/* /usr/local/include/
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                       INSTALLING MySQL C-Connector                       ###\n"
echo "################################################################################\n"

download
unpack
build
cleanup
copy
