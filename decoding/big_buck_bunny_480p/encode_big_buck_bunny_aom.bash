#!/bin/bash
# BIG BUCK BUNNY - LIBAOM - ENCODING (with ffmpeg)

codec="av1"
encoder_name="AOM"
org_seq_name="big_buck_bunny_480p.yuv"
name="bunny"
w=704
h=480
n=300
fps=24
dest_dir="${encoder_name}_${name}"

mkdir ${dest_dir}

for i in {100..1100..50}
do
(/usr/bin/time -o ${dest_dir}/enctime_${i}.txt -f "%U %S %E" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -vcodec ${codec} -b:v ${i}k -cpu-used 3 -enable-intrabc true -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
done

