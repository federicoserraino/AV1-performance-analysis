#!/bin/bash
# STOCKHOLM - SVT_AV1 - ENCODING TWO PASS

codec="av1"
encoder_name="SVTAV1"
org_seq_name="stockholm_720p.yuv"
name="stockholm_2-pass"
w=1280
h=720
n=300
fps=60

curr_dir=`pwd`
dest_dir="${encoder_name}_${name}"

encoder_path="/home/ubuntu/svtav1" # Set param with your svtav1 encoder path
cp -r ${encoder_path} ${dest_dir}
cd ${dest_dir}

encode(){
/usr/bin/time -o enctime_1st-pass_${i}.txt -f "%U %S" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --preset 4 --progress 2 --rc 1 --tbr ${i} --pass 1 --stats file.stat

(/usr/bin/time -o enctime_2nd-pass_${i}.txt -f "%U %S" ./SvtAv1EncApp -i ${curr_dir}/${org_seq_name} -w ${w} -h ${h} -n ${n} --preset 4 --progress 2 --rc 1 --tbr ${i} --pass 2 --stats file.stat -b ${name}_${i}.${codec}) &> encdata_${i}.txt
}

for i in {100..1300..300}
do
    encode
done

for i in {1500..5000..700}
do
    encode
done

cd ${curr_dir}
