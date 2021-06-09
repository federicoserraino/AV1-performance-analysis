#!/bin/bash
# TRACTOR - LIBAOM - ENCODING (with ffmpeg)

codec="av1"
encoder_name="AOM"
org_seq_name="tractor_1080p.yuv"
name="tractor"
w=1920
h=1080
n=300
fps=25
dest_dir="${encoder_name}_${name}"

mkdir ${dest_dir}

encode(){
(/usr/bin/time -o ${dest_dir}/enctime_${i}.txt -f "%U %S %E" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -vcodec ${codec} -b:v ${i}k -cpu-used 3 -enable-intrabc true -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
}

for i in {100..1500..200}
do
    encode
done

for i in {1800..4200..300}
do
    encode
done

