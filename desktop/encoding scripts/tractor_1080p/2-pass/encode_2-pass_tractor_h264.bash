#!/bin/bash
# TRACTOR - H264 - ENCODING TWO PASS (with ffmpeg)

codec="h264"
encoder_name="AVC"
org_seq_name="tractor_1080p.yuv"
name="tractor_2-pass"
w=1920
h=1080
n=300
fps=25
dest_dir="${codec}_${name}"

mkdir ${dest_dir}

for i in {1000..3500..250}
do
/usr/bin/time -o ${dest_dir}/enctime_1st-pass_${i}.txt -f "%U %S" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -c:v libx264 -b ${i}k -pass 1 -preset slow -tune psnr -f rawvideo /dev/null

(/usr/bin/time -o ${dest_dir}/enctime_2nd-pass_${i}.txt -f "%U %S" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -c:v libx264 -b ${i}k -pass 2 -preset slow -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
done
