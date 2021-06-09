#!/bin/bash
# TRACTOR - SVT_AV1 - ENCODING

codec="av1"
encoder_name="SVTAV1"
org_seq_name="tractor_1080p.yuv"
name="tractor"
w=1920
h=1080
n=300
fps=25

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/svtav1" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

encode(){
(/usr/bin/time -o enctime_${i}.txt -f "%U %S %E" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} -b ${name}_${i}.${codec}) &> encdata_${i}.txt
}

for i in {700..1300..200}
do
    encode
done

for i in {1500..5400..300}
do
    encode
done

cd ${curr_dir}
