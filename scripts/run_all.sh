#!/bin/bash
set -x # show commands
set -e # exit on error
set -o pipefail
source script_variables.sh

mkdir -p ${working_dir}
echo ${version_string} > ${working_dir}/version_string
mkdir -p ${tuple_dir}
echo ${version_string} > ${tuple_dir}/version_string

for set in ${sets}; do
    
    archive=${archive_dir}/${set}.tar.gz
    wd=${working_dir}/${set}

    check_existence ${archive}
    
    echo "Extracting contents of ${archive} to ${wd}."
    mkdir -p ${wd}
    
    tar xvzf ${archive} -C ${wd}
    
done

echo "$0: Done preparing."

echo "$0: Now creating tuples."

for set in ${sets}; do
    
    wd=${working_dir}/${set}
    
    for a in ${wd}/**/log.log.bz2; do
        ./create_tuples.sh $a $a
		echo
    done
done


echo "$0: Now collecting tuples in tuple directory."

rm -rf ${tuple_dir}/*.tuple
mkdir -p ${tuple_dir}/
 
for set in ${sets}; do
    wd=${working_dir}/${set}
    cat ${wd}/exp*/*.log_tuple > ${tuple_dir}/${set}.tuple
     ${json_decimate} -period 3 -phase 0 -in ${tuple_dir}/${set}.tuple -out ${tuple_dir}/${set}_0.tuple
     ${json_decimate} -period 3 -phase 1 -in ${tuple_dir}/${set}.tuple -out ${tuple_dir}/${set}_1.tuple
     ${json_decimate} -period 3 -phase 2 -in ${tuple_dir}/${set}.tuple -out ${tuple_dir}/${set}_2.tuple
done

echo "$0: Now solving for all tuples"

for file in ${tuple_dir}/*.tuple; do
    a=`basename ${file} .tuple`
    ${solver} -input_file ${tuple_dir}/${a}.tuple -output_file ${tuple_dir}/${a}_results.json ${solver_options}  


    ${json2matlab}  ${tuple_dir}/${a}_results.json
done


ln -f -s ${tuple_dir} 'last_tuples'


