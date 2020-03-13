#!/bin/bash -x
if [ "x$SLURM_NPROCS" = "x" ] 
then
  if [ "x$SLURM_NTASKS_PER_NODE" = "x" ] 
  then
    SLURM_NTASKS_PER_NODE=1
  fi
  SLURM_NPROCS=`expr $SLURM_JOB_NUM_NODES \* $SLURM_NTASKS_PER_NODE`
else
  if [ "x$SLURM_NTASKS_PER_NODE" = "x" ]
  then
    SLURM_NTASKS_PER_NODE=`expr $SLURM_NPROCS / $SLURM_JOB_NUM_NODES`
  fi
fi

srun hostname -s | sort -u > /tmp/hosts.$SLURM_JOB_ID
awk "{ print \$0 \"-ib slots=$SLURM_NTASKS_PER_NODE\"; }" /tmp/hosts.$SLURM_JOB_ID >/tmp/tmp.$SLURM_JOB_ID
mv /tmp/tmp.$SLURM_JOB_ID /tmp/hosts.$SLURM_JOB_ID

module use /gpfs/u/software/dcs-spack-install/v0133/lmod/linux-rhel7-ppc64le/xl/16.1.1
module load xl_r/16.1.1
module load spectrum-mpi/10.3-i3wnm5t

fft_build_dir=/gpfs/u/home/MPFS/MPFScgzg/barn/xgc/fftw-3.3.8/tests
bin="$fft_build_dir/bench -y orf256 -v2"
#bin="$fft_build_dir/bench -s ib256 -v2"

$bin

rm /tmp/hosts.$SLURM_JOB_ID
