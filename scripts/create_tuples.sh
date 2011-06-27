#!/bin/bash

set -e # exit on error
set -o pipefail
source script_variables.sh


#Verify input
if [ "$1" = "" ] || [ "$2" = "" ]; then
	echo "Usage:
	./create_tuples.sh <laser_log.bz2> <odometry_log.bz2> [data_path] [Calibration_path] [Scan_Matcher_path]"
	exit 1
fi

if [ "$3" = "" ]; then
	DATA=""
else
	DATA="${3}/"
fi

if [ "$4" = "" ]; then
	PATH_CALIB="`pwd`/"
else
	PATH_CALIB="${4}/"
fi

if [ "$5" = "" ]; then
	PATH_SM=""
else
	PATH_SM="${5}/"
fi

#FILES
LAS_FILE_BZ2="${DATA}${1}"
ODO_FILE_BZ2="${DATA}${2}"
LAS_FILE=`dirname ${LAS_FILE_BZ2}`/`basename $LAS_FILE_BZ2 .bz2`
ODO_FILE=`dirname ${ODO_FILE_BZ2}`/`basename $ODO_FILE_BZ2 .bz2`
SM_STATS_FILE="${LAS_FILE}_stats"
SM_OUTPUT_FILE="${LAS_FILE}_out"
TUPLE_FILE="${LAS_FILE}_tuple"
OUT_CALIB_PARAM_FILE="${LAS_FILE}_calibParams"



#funzione per rimuovere file già esistenti
checkrm() {
	local path="$1"
	if [ -e $path ]; then
		echo "Removing old file: $path"
		rm $path
	fi
}

check_exec "bunzip2"
check_existence ${LAS_FILE_BZ2}
check_existence  ${ODO_FILE_BZ2}
checkrm ${SM_STATS_FILE}
checkrm ${TUPLE_FILE}
checkrm ${OUT_CALIB_PARAM_FILE}
checkrm ${LAS_FILE}
checkrm ${ODO_FILE}


# Decompress files
echo -n "$0: Uncompressing files..."
`bunzip2 -k "$LAS_FILE_BZ2"`
if [ ! ${LAS_FILE_BZ2} == ${ODO_FILE_BZ2} ]; then
	`bunzip2 -k "$ODO_FILE_BZ2"`
fi
echo "done."

#Scan Matcher

echo "$0: Decimating file..."

# cat $LAS_FILE   | ld_remove_doubles -epsilon 0.4 > $LAS_FILE.sel

cat ${LAS_FILE} | ${json_decimate} -period ${decimate_period}  > ${LAS_FILE}.sel


echo "$0: Scan Matcher... "
${sm2} -in ${LAS_FILE}.sel -out ${SM_OUTPUT_FILE} -out_stats ${SM_STATS_FILE} ${sm_options}

echo "$0: Syncronization..."
${synchronizer} -las_file ${SM_STATS_FILE} -odo_file ${ODO_FILE} -output ${TUPLE_FILE} ${synchronizer_options}
echo "done"

## THAT'S ALL FOLKS ##
