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

ZONING_FILE=zone_mappings.txt #BAM: I think this specifies which tiles to pull info for which site lat/lon ELM so the entire dataset doesn't have to be pulled
#ZONING_FILE=daymet_elm_mappings.txt  

cwd=$(pwd)
#BAM: makepointdata.py is what gets called to actual pull the data for the points of interest
if srun -n 2 python3 ./makepointdata.py \ #BAM:pretty sure srun needs to be used to submit jobs on baseline
#if python3 ./makepointdata.py \
  --ccsm_input /gpfs/wolf2/cades/cli185/world-shared/e3sm/inputdata \ #this is the location of the input data on baseline, naming s(x) matches what makepointdata.py looks for
  --keep_duplicates \
  --lat_bounds -999,-999 --lon_bounds -999,-999 \ #BAM: -999's are dummy since this is for pulling data for point sims 
  --mysimyr 1850 \ #BAM: start year for model sims (GSWP3 starts 1850)
  --model ELM \
  --surfdata_grid --res hcru_hcru \ #BAM: hcru_hcru means use the default grid resolution, which is 0.5 deg
  --point_list ${ZONING_FILE} \ #BAM: this is where we need to pass the .txt file path that has the lat/lons for the points of interest and their associated tile numbers

then
  wait

  echo "DONE making point data for point_list ${ZONING_FILE} !"

else
  exit &?
fi

cd ${cwd}
