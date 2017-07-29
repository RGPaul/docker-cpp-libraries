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

declare BOOST_LIBS="atomic chrono date_time exception filesystem program_options random signals system thread test"
declare BOOST_VERSION=1.64.0
declare BOOST_VERSION2=1_64_0
declare TOOLSET="gcc"

#=======================================================================================================================
# globals

declare CURRENT_DIR=$(pwd)
declare BOOST_INSTALL_PREFIX="/usr/local"
declare SRCDIR="${CURRENT_DIR}/src"
declare BOOST_TARBALL="${CURRENT_DIR}/boost_$BOOST_VERSION2.tar.gz"
declare BOOST_SRC="${SRCDIR}/boost_${BOOST_VERSION2}"

#=======================================================================================================================

function download()
{
    if [ ! -s ${BOOST_TARBALL} ]; then
        echo "Downloading boost ${BOOST_VERSION}"
        curl -L -o "${BOOST_TARBALL}" \
          http://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION2}.tar.gz/download
    else
        echo "${BOOST_TARBALL} already existing"
    fi
}

#=======================================================================================================================

function unpack()
{
    [ -f "${BOOST_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking boost into \"${SRCDIR}\"..."

    [ -d ${SRCDIR} ]    || mkdir -p "${SRCDIR}"
    [ -d ${BOOST_SRC} ] || ( cd "${SRCDIR}"; tar -xvzf "${BOOST_TARBALL}" )
    [ -d ${BOOST_SRC} ] && echo "    ...unpacked as ${BOOST_SRC}"
}

#=======================================================================================================================

function bootstrap()
{
    cd ${BOOST_SRC}
    local BOOTSTRAP_LIBS=${BOOST_LIBS}
    local BOOST_LIBS_COMMA=$(echo ${BOOTSTRAP_LIBS} | sed -e "s/ /,/g")
    echo "Bootstrapping for $1 (with libs ${BOOST_LIBS_COMMA})"
    ./bootstrap.sh --with-toolset=${TOOLSET} --prefix=${BOOST_INSTALL_PREFIX} --without-libraries=python
}

#=======================================================================================================================

function build()
{
    echo "build boost with b2"
    cd ${BOOST_SRC}
    ./b2 link=static address-model=64 architecture=x86
}

#=======================================================================================================================

function install()
{
    echo "install boost with b2"
    cd ${BOOST_SRC}
    ./b2 link=static address-model=64 architecture=x86 install
}

#=======================================================================================================================

function cleanup()
{
    echo "cleanup boost folders"
    rm -rf ${SRCDIR}
    cd ${CURRENT_DIR}
}

#=======================================================================================================================


echo "################################################################################\n"
echo "###                             INSTALLING Boost                             ###\n"
echo "################################################################################\n"


download
unpack
bootstrap
build
install
cleanup

