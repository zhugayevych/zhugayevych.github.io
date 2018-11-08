#!/bin/bash

#SBATCH -N 1
#SBATCH -c 16
#SBATCH -t 24:00:00
#SBATCH -o %x.e%j
#SBATCH -e %x.e%j.err
#SBATCH -p AMG
#SBATCH --mem-per-cpu=7500

#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS=1

echo 'JOBNAME' $SLURM_JOB_NAME
echo 'NUM_THREADS' $OMP_NUM_THREADS
hostname
date

#ulimit -u unlimited
module load Compiler/Intel/17u8  Q-Ch/VASP/5.4.4_OPT

#cd ~/vasp/$SLURM_JOB_NAME
export SCR=/scr/$SLURM_JOB_NAME
mkdir -p $SCR
cp ~/vasp/$SLURM_JOB_NAME/* $SCR/
cd $SCR
mpirun -np $SLURM_JOB_CPUS_PER_NODE vasp_std
cp -r $SCR/* ~/vasp/$SLURM_JOB_NAME/
cd ~/vasp/$SLURM_JOB_NAME/
rm -rf $SCR

date
rm -f ~/$SLURM_JOB_NAME.e$SLURM_JOB_ID.err
