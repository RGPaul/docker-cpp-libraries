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

declare OPENLDAP_VERSION=2.4.45

# ----------------------------------------------------------------------------------------------------------------------
# globals

declare CURRENT_DIR=$(pwd)
declare OPENLDAP_TARBALL="openldap-${OPENLDAP_VERSION}.tgz"
declare OPENLDAP_DOWNLOAD_URI="ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/${OPENLDAP_TARBALL}"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${OPENLDAP_TARBALL} ]; then
        echo "Downloading ${OPENLDAP_TARBALL}"
        curl -L -o ${OPENLDAP_TARBALL} ${OPENLDAP_DOWNLOAD_URI}
    else
        echo "${OPENLDAP_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${OPENLDAP_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${OPENLDAP_TARBALL}\"..."

    tar -xvzf "${OPENLDAP_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    cd openldap-${OPENLDAP_VERSION}

    # configure / build / install (to seperate folder)
    ./configure --disable-slapd --disable-shared --enable-static
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/openldap-${OPENLDAP_VERSION}"
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                            INSTALLING OpenLDAP                           ###\n"
echo "################################################################################\n"


download
unpack
build
cleanup
