Download from github: netcdf-c-4.5.0.tar.gz  
Download from github: netcdf-fortran-4.4.0.tar.gz  
<br>  

su cse  

module load mpt/2.14  
module load intel-compilers-17/17.0.2.174   
module load hdf5parallel/1.10.1-intel17-mpt214  
<br>
 
cd /lustre/sw/netcdfparallel/4.5.0-intel17-mpt214  
tar -xvf netcdf-c-4.5.0.tar.gz  
cd netcdf-c-4.5.0  
  
export MPICC_CC=icc  
export MPICXX_CXX=icpc  
export CPPFLAGS=-I/lustre/sw/hdf5parallel/1.10.1-intel17-mpt214/include  
export LDFLAGS=-L/lustre/sw/hdf5parallel/1.10.1-intel17-mpt214/lib  
export CC=icc   

./configure --disable-dap --enable-parallel-tests --enable-fortran --disable-netcdf-4 --prefix=/lustre/sw/netcdfparallel/lustre/sw/netcdfparallel/4.5.0-intel17-mpt214  

make all  
make check install  
<br>
   
cd /lustre/sw/netcdfparallel/4.5.0-intel17-mpt214  
tar -xvf netcdf-fortran-4.4.0.tar.gz  
cd netcdf-fortran-4.4.0  
    
export NCDIR=/lustre/sw/netcdfparallel/4.5.0-intel17-mpt214  
  
export CC=icc  
export FC=ifort  
  
export LD_LIBRARY_PATH=$NCDIR/lib:$LD_LIBRARY_PATH  
  
export NFDIR=$NCDIR  
export CPPFLAGS=-I$NCDIR/include  
export LDFLAGS=-L$NCDIR/lib  
  
./configure --prefix=$NFDIR  
  
make all  
make check install  
<br>

Module at /lustre/sw/modulefiles/netcdf-parallel/4.5.0-intel17-mpt214  