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

declare AWS_SDK_VERSION=1.1.33

#=======================================================================================================================
# globals

declare CURRENT_DIR=$(pwd)
declare AWS_SDK_TARBALL="aws-sdk-${AWS_SDK_VERSION}.tar.gz"
declare AWS_SDK_DOWNLOAD_URI="https://github.com/aws/aws-sdk-cpp/archive/${AWS_SDK_VERSION}.tar.gz"


#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${AWS_SDK_TARBALL} ]; then
        echo "Downloading ${AWS_SDK_TARBALL}"
        curl -L -o ${AWS_SDK_TARBALL} ${AWS_SDK_DOWNLOAD_URI}
    else
        echo "${AWS_SDK_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${AWS_SDK_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${AWS_SDK_TARBALL}\"..."

    tar -xvzf "${AWS_SDK_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # cmake / build
    rm -r "${CURRENT_DIR}/build" || true
    mkdir "${CURRENT_DIR}/build"
    cd "${CURRENT_DIR}/build"

    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DENABLE_UNITY_BUILD=ON -Wno-dev \
          "${CURRENT_DIR}/aws-sdk-cpp-${AWS_SDK_VERSION}"
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    cd "${CURRENT_DIR}"
    rm -r "${CURRENT_DIR}/build"
    rm -r "${CURRENT_DIR}/aws-sdk-cpp-${AWS_SDK_VERSION}"
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                        INSTALLING AWS SDK for C++                        ###\n"
echo "################################################################################\n"

download
unpack
build
cleanup
