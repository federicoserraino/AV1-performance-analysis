#!/bin/bash
# MARATHON - HEVC - ENCODING TWO PASS (with ffmpeg)

codec="hevc"
encoder_name="HEVC"
org_seq_name="marathon_4k.yuv"
name="marathon_2-pass"
w=3840
h=2160
n=150
fps=30
dest_dir="${codec}_${name}"

mkdir ${dest_dir}

encode() {
/usr/bin/time -o ${dest_dir}/enctime_1st-pass_${i}.txt -f "%U %S" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -c:v libx265 -b ${i}k -x265-params pass=1 -preset slow -tune psnr -f rawvideo /dev/null

(/usr/bin/time -o ${dest_dir}/enctime_2nd-pass_${i}.txt -f "%U %S" ffmpeg -y -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${w}x${h} -r ${fps} -i ${org_seq_name} -c:v libx265 -b ${i}k -x265-params pass=2 -preset slow -tune psnr -f mpeg2video ${dest_dir}/${name}_${i}.${codec}) &> ${dest_dir}/encdata_${i}.txt
}

for i in {5000..30000..2500}
do
    encode
done

