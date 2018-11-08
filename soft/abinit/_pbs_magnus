#!/bin/bash
#SBATCH -o %x.e%j
#SBATCH -e %x.e%j.err
#SBATCH -N 1        ## --nodes=
#SBATCH -c 16       ## --cpus-per-task=
#SBATCH -t 24:00:00
#SBATCH -p AMG
#SBATCH --ntasks-per-node=1
#SBATCH --mem=0

echo 'JOB_NAME' $SLURM_JOB_NAME
echo 'JOB_ID' $SLURM_JOB_ID
echo 'JOB_CPUS_PER_NODE' $SLURM_JOB_CPUS_PER_NODE
hostname
date

module load Compiler/Intel/17u8 Q-Ch/ABINIT/8.10.3/intel/2017u8

cd ~/abinit

mpirun -np $SLURM_JOB_CPUS_PER_NODE abinit < $SLURM_JOB_NAME.files > $SLURM_JOB_NAME.log

date
rm -f ~/$SLURM_JOB_NAME.e$SLURM_JOB_ID.err
