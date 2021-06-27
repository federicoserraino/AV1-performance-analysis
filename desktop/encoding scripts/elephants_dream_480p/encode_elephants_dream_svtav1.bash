#!/bin/bash
# ELEPHANTS DREAM - SVT_AV1 - ENCODING

codec="av1"
encoder_name="SVTAV1"
org_seq_name="elephants_dream_480p.yuv"
name="elephants"
w=704
h=480
n=300
fps=24

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/svtav1" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

# Encoding both VBR and CQP mode

for i in {100..1500..100}
do
(/usr/bin/time -o enctime_${i}.txt -f "%U %S %E" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} -b ${name}_${i}.${codec}) &> encdata_${i}.txt
done

for ((i=20 ; i>=10 ; i-=2))
do
(/usr/bin/time -o enctime_q${i}.txt -f "%U %S %E" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 0 -q ${i} -b ${name}_q${i}.${codec}) &> encdata_q${i}.txt
done

cd ${curr_dir}
