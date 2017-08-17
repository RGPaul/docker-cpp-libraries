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

echo "################################################################################\n"
echo "###                             INSTALLING cnats                             ###\n"
echo "################################################################################\n"

declare CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare LIBRARY_VERSION=1.6.0

# only download if not already present
if [ ! -f cnats-${LIBRARY_VERSION}.tar.gz ]; then
    curl -L -o cnats-${LIBRARY_VERSION}.tar.gz https://github.com/nats-io/cnats/archive/v${LIBRARY_VERSION}.tar.gz
fi

# unpack tar file
tar -xvzf cnats-${LIBRARY_VERSION}.tar.gz

# create a clean build folder
rm -rf build || true ; mkdir build ; cd build

# cmake / build
cmake ../cnats-${LIBRARY_VERSION} -DNATS_BUILD_WITH_TLS=ON
make
make install

# delete shared library
rm /usr/local/lib/libnats.so
mv /usr/local/lib/libnats_static.a /usr/local/lib/libnats.a

# cleanup
cd ..
rm -rf cnats-${LIBRARY_VERSION}
rm -rf build

