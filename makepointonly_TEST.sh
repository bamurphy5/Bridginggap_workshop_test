#!/bin/bash -f

source ~/.bashrc

#ZONING_FILE=zone_mappings.txt
ZONING_FILE=daymet_elm_mappings.txt #BAM: this specifies which DAYMET tiles to pull info for ELM so the entire dataset doesn't have to be pulled, not sure what the corresponding version of this would be for GWSP3, need to find this .txt file and look

cwd=$(pwd)
#BAM: makepointdata.py is what gets called to actual pull the data for the points of interest
if python3 ./makepointdata.py \
  --ccsm_input /Users/f9y/clm4_5_inputdata \ #BAM: will need to update this to wherever Fengming has the global gridded ELM datasets stored on CADES baseline...
  --keep_duplicates \
  --lat_bounds -999,-999 --lon_bounds -999,-999 \ #BAM: -999's are dummy since this is for pulling data for point sims 
  --mysimyr 1850 \ #BAM: start year for model sims (GSWP3 starts 1850)
  --model ELM \
  --surfdata_grid --res hcru_hcru \ #BAM: hcru_hcru means use the default grid resolution, which is 0.5 deg
  --point_list ${ZONING_FILE} \ #BAM: this is where we need to pass the .txt file path that has the lat/lons for the points of interest
  --point_area_kmxkm 1.0 & sleep 10 #BAM: not sure what the sleep 10 command does...

then
  wait

  echo "DONE making point data for point_list ${ZONING_FILE} !"

else
  exit &?
fi

cd ${cwd}
