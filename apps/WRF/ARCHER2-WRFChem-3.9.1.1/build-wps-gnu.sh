#!/usr/bin/env bash

# From the default envoronment
# invoke as "bash ./wps-build-gnu.sh"

set -e

export MY_INSTALL=`pwd`

# Watch out: don't have something with "gcc" here; it will get nuked
# by sed later on...
# The main WRF directory is...

export WRF_DIR=${MY_INSTALL}/WRF-3.9.1.1
export JASPER_ROOT=${MY_INSTALL}/grib2

# Install [as required]
wget https://github.com/wrf-model/WPS/archive/refs/tags/v3.9.1.tar.gz
tar zxf v3.9.1.tar.gz
cd WPS-3.9.1

./clean

module -s restore PrgEnv-gnu
module swap gcc gcc/9.3.0
module load cray-hdf5
module load cray-netcdf

# Module cray-netcdf is associated with ${NETCDF_DIR}
# which must be set for the configure stage...

export NETCDF=${NETCDF_DIR}

# JASPER/PNG stuff

export JASPERLIB=${JASPER_ROOT}/lib
export JASPERINC=${JASPER_ROOT}/include

# The configuration selection is "3" for gcc/gfortran
# but we must again edit the resultant configure.wps to
# replace gfortran by ftn etc.

./configure <<EOF
3
EOF

# simplfying the compiler choices, to use cc and ftn (which call the same compilers, but apply system specific flags)
sed -i -e 's/mpicc -cc=gcc/cc/'     configure.wps
sed -i -e 's/mpif90 -f90=gfortran/ftn/'   configure.wps
sed -i -e 's/gcc/cc/'       configure.wps
sed -i -e 's/gfortran/ftn/' configure.wps

# applying this fix for mismatched integer kinds:
# https://github.com/wrf-model/WPS/pull/119
sed -i -e '172 s/i-1)/i-1_2)/' -e '207 s/i-1)/i-1_1)/' ungrib/src/ngl/g2/intmath.f

# Compile

./compile

# The make looks like a make -k, so check we have really got three executables
# at the end:

ls -l *exe
