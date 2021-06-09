#!/bin/bash
# ELEPHANTS DREAM - SVT_AV1 - ENCODING TWO PASS

codec="av1"
encoder_name="SVTAV1"
org_seq_name="elephants_dream_480p.yuv"
name="elephants_2-pass"
w=704
h=480
n=300
fps=24

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/svtav1" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

for i in {100..2000..200}
do
/usr/bin/time -o enctime_1st-pass_${i}.txt -f "%U %S" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} --pass 1 --stats file.stat

(/usr/bin/time -o enctime_2nd-pass_${i}.txt -f "%U %S" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --fps ${fps} --preset 4 --progress 2 --rc 1 --tbr ${i} --pass 2 --stats file.stat -b ${name}_${i}.${codec}) &> encdata_${i}.txt
done

cd ${curr_dir}
