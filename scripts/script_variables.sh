#!/bin/bash

archive_dir="../data/"

json_decimate=json_decimate
json2matlab=json2matlab

#Executables
sm2="sm2"

calib_bin=../bin/
synchronizer=${calib_bin}/synchronizer
solver=${calib_bin}/solver2


# parameters
sets="l90 lmov lstraight"
decimate_period=4
sm_options="-restart 0 -recover_from_error 1 -max_iterations 1000 -min_reading 0.3 -max_angular_correction_deg 10 -max_linear_correction 0.05 -epsilon_xy 0.000001 -epsilon_theta 0.000001 "
synchronizer_options="-tk_threshold 5  -perc_threshold 0.95 -time_tolerance 0.5"
solver_options="-mode 0  -outliers_iterations 4"


check_exec() {
	local path="$1"
	if ! type $path >/dev/null 2>&1; then
		echo "ERROR: \"$path\" not found."
		echo "       This is needed to work. "
		exit 2
	fi
}

check_existence() {
	local type="$1"
	local path="$2"
	if [ ! -e $path ]; then
		echo "Missing $type: $path"
		exit 1
	fi
}


# Check we can find everything
check_exec md5sum
check_exec awk
check_exec ${json_decimate}
check_exec ${sm2}
check_exec ${json2matlab}
check_exec ${solver}
check_exec ${synchronizer}
check_existence ${archive_dir}


version_string="sets=${sets}\ndecimate_period=${decimate_period}\nsm_options=${sm_options}\nsynchronizer_options=${synchronizer_options}\nsolver_options=${solver_options}"
version_id=`echo ${version_string}|md5sum|awk '{print $1}'`

working_dir="working_dir_${version_id}/"
tuple_dir="tuples_${version_id}/"

echo version_id: ${version_id}
echo working_dir: ${working_dir}
echo tuple_dir: ${tuple_dir}


