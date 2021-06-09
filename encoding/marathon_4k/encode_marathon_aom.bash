#!/bin/bash
# MARATHON - LIBAOM - ENCODING (with ffmpeg)

codec="av1"
encoder_name="AOM"
org_seq_name="marathon_4k.yuv"
name="marathon"
w=3840
h=2160
n=150
fps=30
dest_dir="${encoder_name}_${name}"

mkdir ${dest_dir}

encode() {
(/usr/bin/time -o ${dest_dir}/enctime_${i}.txt -f "%U %S %E" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -vcodec ${codec} -b:v ${i}k -cpu-used 3 -enable-intrabc true -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
}

for i in {2000..5000..1500}
do
    encode
done

for i in {7500..18000..1500}
do
encode
done
