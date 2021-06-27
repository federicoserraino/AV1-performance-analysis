#!/bin/bash
# STOCKHOLM - HEVC - ENCODING (with ffmpeg)

codec="hevc"
encoder_name="HEVC"
org_seq_name="stockholm_720p.yuv"
name="stockholm"
w=1280
h=720
n=300
fps=60
dest_dir="${codec}_${name}"

mkdir ${dest_dir}

encode() {
(/usr/bin/time -o ${dest_dir}/enctime_${i}.txt -f "%U %S %E" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -vcodec ${codec} -b ${i}k -preset slow -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
}

for i in {100..1300..200}
do
    encode
done

for i in {1500..6500..500}
do
    encode
done
