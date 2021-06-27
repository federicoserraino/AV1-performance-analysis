#!/bin/bash
# SUNFLOWER - SVT_AV1 - ENCODING

codec="av1"
encoder_name="SVTAV1"
org_seq_name="sunflower_1080p.yuv"
name="sunflower"
w=1920
h=1080
n=300
fps=25

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/svtav1" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

# Encoding both VBR and CQP mode

encode_vbr(){
(/usr/bin/time -o enctime_${i}.txt -f "%U %S %E" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} -b ${name}_${i}.${codec}) &> encdata_${i}.txt
}

for i in {500..1100..200}
do
    encode_vbr
done

for i in {1400..4700..300}
do
    encode_vbr
done

for ((i=19 ; i>=16 ; i--))
do
(/usr/bin/time -o enctime_q${i}.txt -f "%U %S %E" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 0 -q ${i} -b ${name}_q${i}.${codec}) &> encdata_q${i}.txt
done

cd ${curr_dir}
