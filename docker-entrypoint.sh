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

# if the command starts with install, we will install (compile) all dependencies
if [ "$1" = 'install' ]; then

  if [ -f "/root/.install_done" ]; then
    echo "installation was previously executed"
    exec bash
  fi

  cd /root/deps

  if [ "${INSTALL_LIBRESSL}" = "TRUE" ]; then
    /root/deps/install-libressl.sh
  fi

  if [ "${INSTALL_OPENSSL}" = "TRUE" ]; then
    /root/deps/install-openssl.sh
  fi

  # required OpenSSL / LibreSSL
  if [ "${INSTALL_AWS_SDK}" = "TRUE" ]; then
    /root/deps/install-aws-sdk.sh
  fi

  if [ "${INSTALL_BOOST}" = "TRUE" ]; then
    /root/deps/install-boost.sh
  fi

  if [ "${INSTALL_NLOHMANN_JSON}" = "TRUE" ]; then
    /root/deps/install-nlohmann-json.sh
  fi

  # required OpenSSL / LibreSSL
  if [ "${INSTALL_OPENLDAP}" = "TRUE" ]; then
    /root/deps/install-openldap.sh
  fi

  if [ "${INSTALL_MYSQLCLIENT}" = "TRUE" ]; then
    /root/deps/install-mysqlclient.sh
  fi

  if [ "${INSTALL_SQLITE3}" = "TRUE" ]; then
    /root/deps/install-sqlite3.sh
  fi

  # requires Boost / MySQLClient / SQLite3
  if [ "${INSTALL_SOCI}" = "TRUE" ]; then
    /root/deps/./install-soci.sh
  fi

  # requires Boost / LibreSSL or OpenSSL
  if [ "${INSTALL_CPP_REST_SDK}" = "TRUE" ]; then
    /root/deps/install-cpprestsdk.sh
  fi

  if [ "${INSTALL_CRYPTOPP}" = "TRUE" ]; then
    /root/deps/install-cryptopp.sh
  fi

  if [ "${INSTALL_PLUSTACHE}" = "TRUE" ]; then
    /root/deps/install-plustache.sh
  fi

  # requires OpenSSL / LibreSSL
  if [ "${INSTALL_CNATS}" = "TRUE" ]; then
    /root/deps/install-cnats.sh
  fi

  touch "/root/.install_done"

  echo "################################################################################\n"
  echo "###                        INSTALLING Libraries done                         ###\n"
  echo "################################################################################\n"

else
  exec "$@"
fi
