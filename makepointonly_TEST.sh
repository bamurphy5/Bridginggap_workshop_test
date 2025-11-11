#!/bin/bash -f
#SBATCH --time 02:00:00
#SBATCH -A cli185
#SBATCH -p batch_ccsi
#SBATCH --mem=0G
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -c 1
#SBATCH --ntasks-per-node 2
#SBATCH --job-name=makepointonly
#SBATCH -o ./%j-output.txt
#SBATCH -e ./%j-error.txt
#SBATCH  --exclusive 

source $MODULESHOME/init/bash
module load nco

ZONING_FILE=pointlist_example.txt  

cwd=$(pwd)

if srun -n 2 python3 ./makepointdata.py \ 
#if python3 ./makepointdata.py \
  --ccsm_input /gpfs/wolf2/cades/cli185/world-shared/e3sm/inputdata \ 
  --keep_duplicates \
  --lat_bounds -999,-999 --lon_bounds -999,-999 \ 
  --mysimyr 1850 \ 
  --model ELM \
  --surfdata_grid --res hcru_hcru \ 
  --point_list ${ZONING_FILE} \ 
then
  wait

  echo "DONE making point data for point_list ${ZONING_FILE} !"

else
  exit &?
fi

cd ${cwd}
