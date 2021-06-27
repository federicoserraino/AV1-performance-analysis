#!/bin/bash
# BIG BUCK BUNNY - RAV1E - ENCODING

codec="av1"
encoder_name="RAV1E"
org_seq_name="big_buck_bunny_480p.y4m"
name="bunny"
w=704
h=480
n=300
fps=24

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

mkdir ${dest_dir}

encoder_path="/home/ubuntu/rav2" # Set param with your svtav1 encoder path
cp -r ${encoder_path}/* ${dest_dir}
cd ${dest_dir}

for i in {100..1500..100}
do
(/usr/bin/time -o enctime_${i}.txt -f "%U %S %E" ./rav1e ${curr_dir}/${org_seq_name} -s 1 --tiles 4 --tune Psnr -b ${i} -o ${name}_${i}.ivf) &> encdata_${i}.txt
done

cd ${curr_dir}
