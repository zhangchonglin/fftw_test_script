#!/bin/bash
nodes=1
nprocs=1

sbatch -t 300 -N $nodes -n $nprocs ./run_aimos_xgc.sh

