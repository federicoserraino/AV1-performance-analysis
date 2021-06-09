#!/bin/bash
# MARATHON - H264 - ENCODING (with ffmpeg)

codec="h264"
encoder_name="AVC"
org_seq_name="marathon_4k.yuv"
name="marathon"
w=3840
h=2160
n=150
fps=30
dest_dir="${codec}_${name}"

mkdir ${dest_dir}

for i in {5000..30000..2500}
do
(/usr/bin/time -o ${dest_dir}/enctime_${i}.txt -f "%U %S %E" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -vcodec ${codec} -b ${i}k -preset slow -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
done
