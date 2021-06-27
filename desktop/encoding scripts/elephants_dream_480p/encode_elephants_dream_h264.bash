#!/bin/bash
# ELEPHANTS DREAM - H264 - ENCODING (with ffmpeg)

codec="h264"
encoder_name="AVC"
org_seq_name="elephants_dream_480p.yuv"
name="elephants"
w=704
h=480
n=300
fps=24
dest_dir="${codec}_${name}"

mkdir ${dest_dir}

for i in {100..1800..100}
do
(/usr/bin/time -o ${dest_dir}/enctime_${i}.txt -f "%U %S %E" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -vcodec ${codec} -b ${i}k -preset slow -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
done
