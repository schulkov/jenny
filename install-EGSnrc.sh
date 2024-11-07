#!/bin/bash

# depends on: libmotif-dev qtbase5-dev

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
unset LD_LIBRARY_PATH
set -euo pipefail

INSTALLDIR="${HOME}/software"
BASHRC="${HOME}/.bashrc"
SCRIPTDIR=`pwd`/`dirname ${0}`

mkdir -p ${INSTALLDIR}

echo "*** COMPILING EGSnrc ... ***"
cd ${INSTALLDIR}
if [ ! -d EGSnrc ]; then
   git clone https://github.com/nrc-cnrc/EGSnrc.git
   cd EGSnrc
   git checkout -b rev_v2023a v2023a
fi
cd "${INSTALLDIR}/EGSnrc"
echo -ne "\n\n\n\n\n\n\n\n\n\n\n\nyes\n\n\n1\n" | HEN_HOUSE/scripts/configure

export EGS_HOME=${INSTALLDIR}/EGSnrc/egs_home/
export EGS_CONFIG=${INSTALLDIR}/EGSnrc/HEN_HOUSE/specs/linux.conf
set +e
source ${INSTALLDIR}/EGSnrc/HEN_HOUSE/scripts/egsnrc_bashrc_additions
set -e

export QTDIR=/usr/lib/qt5
export QT_SELECT=qt5
cd ${HEN_HOUSE}/egs++/view
make
cd ${HEN_HOUSE}/gui
make

sed -e '/^# >>> EGSnrc >>>/,/^# <<< EGSnrc <<</d' -i ${BASHRC}
if [ -f "${INSTALLDIR}/EGSnrc/HEN_HOUSE/scripts/egsnrc_bashrc_additions" ]; then
cat << EOF >> ${BASHRC}
# >>> EGSnrc >>>
export EGS_HOME=${INSTALLDIR}/EGSnrc/egs_home/
export EGS_CONFIG=${INSTALLDIR}/EGSnrc/HEN_HOUSE/specs/linux.conf
source ${INSTALLDIR}/EGSnrc/HEN_HOUSE/scripts/egsnrc_bashrc_additions
# <<< EGSnrc <<<
EOF
fi

echo "*** EGSnrc has been installed successfully ***"

