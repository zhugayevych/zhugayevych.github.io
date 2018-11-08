#!/bin/bash

jobname=
ncores=16
nnodes=1
walltime=24:00:00
queue=AMG
prog=M

while getopts :J:n:N:t:p:P: opt; do
 case $opt in
  J) jobname=$OPTARG;;
  n) ncores=$OPTARG;;
  N) nnodes=$OPTARG;;
  t) walltime=$OPTARG;;
  p) queue=$OPTARG;;
  P) prog=$OPTARG;;
  ?) echo "Invalid option: -$OPTARG"
     echo "Usage: _pbs [-J jobname] [-n ncores] [-N nnodes] [-t walltime] [-p queue] [-P prog]"
     exit;;
 esac
done

echo "jobname=$jobname, ncores=$ncores, nnodes=$nnodes, walltime=$walltime, queue=$queue, prog=$prog"

if [ "$jobname" == "" ];  then echo "Invalid jobname: provide nonempty job name"; exit; fi
if [ "$nnodes" -ne "1" ]; then echo "Invalid nnodes: only 1 node can be requested"; exit; fi
if [ "$queue" != "AMG" ]; then echo "Invalid queue: only AMG queue is available"; exit; fi

#sbatch -J $jobname -c $ncores -N $nnodes -t $walltime -p $queue /opt/cms/q-ch/vasp/5.4.4.16052018/bin/vasp_std --exclude=node-amg03

case $prog in
 M) sbatch -J $jobname -c $ncores -N $nnodes -t $walltime -p $queue ~/vasp/vasp544;;
 G) sbatch -J $jobname -c $ncores -N $nnodes -t $walltime -p $queue /opt/cms/q-ch/vasp/5.4.4.16052018/bin/vasp_gam;;
 N) sbatch -J $jobname -c $ncores -N $nnodes -t $walltime -p $queue /opt/cms/q-ch/vasp/5.4.4.16052018/bin/vasp_ncl;;
 *) echo "Invalid prog=$prog, can be one of [M,G,N]"
    exit;;
esac
