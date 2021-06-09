#!/bin/bash
# ELEPHANTS DREAM - RAV1E - ENCODING

codec="av1"
encoder_name="RAV1E"
org_seq_name="elephants_dream_480p.y4m"
name="elephants"
w=704
h=480
n=300
fps=24

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/rav1e" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

for i in {100..2000..100}
do
(/usr/bin/time -o enctime_${i}.txt -f "%U %S %E" ./rav1e ${curr_dir}/${org_seq_name} -s 1 --tiles 4 --tune Psnr -b ${i} -o ${name}_${i}.ivf) &> encdata_${i}.txt
done

cd ${curr_dir}
