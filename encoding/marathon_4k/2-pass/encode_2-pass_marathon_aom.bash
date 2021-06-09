#!/bin/bash
# MARATHON - LIBAOM - ENCODING TWO PASS (with ffmpeg)

codec="av1"
encoder_name="AOM"
org_seq_name="marathon_4k.yuv"
name="marathon_2-pass"
w=3840
h=2160
n=150
fps=30
dest_dir="${encoder_name}_${name}"

mkdir ${dest_dir}

encode() {
/usr/bin/time -o ${dest_dir}/enctime_1st-pass_${i}.txt -f "%U %S" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -c:v libaom-av1 -b:v ${i}k -pass 1 -cpu-used 3 -enable-intrabc true -tune psnr -f rawvideo /dev/null

(/usr/bin/time -o ${dest_dir}/enctime_2nd-pass_${i}.txt -f "%U %S" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -c:v libaom-av1 -b:v ${i}k -pass 2 -cpu-used 3 -enable-intrabc true -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
}

for i in {5000..30000..2500}
do
    encode
done
