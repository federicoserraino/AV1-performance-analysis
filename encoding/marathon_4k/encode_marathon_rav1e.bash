#!/bin/bash
# MARATHON - RAV1E - ENCODING

codec="av1"
encoder_name="RAV1E"
org_seq_name="marathon_4k.y4m"
name="marathon"
w=3840
h=2160
n=150
fps=30

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/rav1e" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

for i in {5000..30000..2500}
do
(/usr/bin/time -o enctime_${i}.txt -f "%U %S %E" ./rav1e ${curr_dir}/${org_seq_name} -s 1 --tiles 4 --tune Psnr -b ${i} -o ${name}_${i}.ivf) &> encdata_${i}.txt
done

cd ${curr_dir}
