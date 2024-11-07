#!/bin/bash

# depends on: cmake libmotif-dev qtbase5-dev libsoqt520-dev libxerces-c-dev libvtk9-dev libvtk9-qt-dev libcoin-dev

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
unset LD_LIBRARY_PATH
set -euo pipefail

INSTALLDIR="${HOME}/software"
BASHRC="${HOME}/.bashrc"
SCRIPTDIR=`pwd`/`dirname ${0}`

mkdir -p ${INSTALLDIR}

echo "*** COMPILING Geant4 ... ***"
cd ${INSTALLDIR}
if [ ! -f geant4-v11.2.2.tar.bz2 ]; then
   wget https://gitlab.cern.ch/geant4/geant4/-/archive/v11.2.2/geant4-v11.2.2.tar.bz2
fi
if [ ! -d geant4-v11.2.2 ]; then
   tar -xjf geant4-v11.2.2.tar.bz2
   patch ${INSTALLDIR}/geant4-v11.2.2/source/visualization/Vtk/include/private/G4VtkUnstructuredGridPipeline.hh ${SCRIPTDIR}/G4VtkUnstructuredGridPipeline.patch
fi
cd geant4-v11.2.2
mkdir -p build install
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/geant4-v11.2.2/install -DGEANT4_USE_VTK=on -DGEANT4_USE_XM=on -DGEANT4_USE_FREETYPE=on -DGEANT4_USE_GDML=on -DGEANT4_USE_HDF5=on -DGEANT4_USE_QT=on -DGEANT4_USE_INVENTOR_QT=on -DGEANT4_USE_OPENGL_X11=on -DGEANT4_USE_RAYTRACER_X11=on -DGEANT4_INSTALL_DATA=on -DGEANT4_INSTALL_DATASETS_TENDL=on 
make -j 4
make install

sed -e '/^# >>> geant4 >>>/,/^# <<< geant4 <<</d' -i ${BASHRC}
if [ -f "${INSTALLDIR}/geant4-v11.2.2/install/bin/geant4.sh" ]; then
cat << EOF >> ${BASHRC}
# >>> geant4 >>>
source ${INSTALLDIR}/geant4-v11.2.2/install/bin/geant4.sh
# <<< geant4 <<<
EOF
fi

echo "*** Geant4 has been installed successfully ***"
