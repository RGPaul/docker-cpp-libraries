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

declare NLOHMANN_JSON_VERSION=2.1.1

#=======================================================================================================================
# globals

declare CURRENT_DIR=$(pwd)
declare NLOHMANN_FOLDER="json-${NLOHMANN_JSON_VERSION}"
declare NLOHMANN_TARBALL="nlohmann-json-${NLOHMANN_JSON_VERSION}.tar.gz"
declare NLOHMANN_DOWNLOAD_URI="https://github.com/nlohmann/json/archive/v${NLOHMANN_JSON_VERSION}.tar.gz"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${NLOHMANN_TARBALL} ]; then
        echo "Downloading ${NLOHMANN_DOWNLOAD_URI}"
        mkdir "${NLOHMANN_FOLDER}" || true
        curl -L -o ${NLOHMANN_TARBALL} ${NLOHMANN_DOWNLOAD_URI}
    else
        echo "${NLOHMANN_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${NLOHMANN_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${NLOHMANN_TARBALL}\"..."

    tar -xvzf "${NLOHMANN_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # cmake / build / install
    cd ${NLOHMANN_FOLDER}
    cmake .
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/${NLOHMANN_FOLDER}"
}


#=======================================================================================================================

echo "################################################################################\n"
echo "###                       INSTALLING Niels Lohmann JSON                      ###\n"
echo "################################################################################\n"


download
unpack
build
cleanup
