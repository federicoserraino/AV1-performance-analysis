#!/bin/bash
# TRACTOR - SVT_AV1 - ENCODING TWO PASS

codec="av1"
encoder_name="SVTAV1"
org_seq_name="tractor_1080p.yuv"
name="tractor_2-pass"
w=1920
h=1080
n=300
fps=25

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/svtav1" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

for i in {1000..3500..250}
do
/usr/bin/time -o enctime_1st-pass_${i}.txt -f "%U %S" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} --pass 1 --stats file.stat

(/usr/bin/time -o enctime_2nd-pass_${i}.txt -f "%U %S" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} --pass 2 --stats file.stat -b ${name}_${i}.${codec}) &> encdata_${i}.txt
done

cd ${curr_dir}
