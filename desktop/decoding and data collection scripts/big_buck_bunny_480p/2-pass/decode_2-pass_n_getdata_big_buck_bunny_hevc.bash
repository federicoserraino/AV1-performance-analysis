#!/bin/bash
# BIG BUCK BUNNY - HEVC - TWO PASS DECODING (with ffmpeg) AND GET DATA

codec="hevc"
encoder_name="HEVC"
seq_name="bunny_2-pass"
org_seq_name="big_buck_bunny_480p.yuv"
w=704
h=480
n=300

curr_dir=`pwd`
dest_dir="${codec}_${seq_name}"
output_file="big_buck_bunny_2-pass_480p.csv"
vmaf_dir="/home/ubuntu/vmaf" # Set param with your vmaf path

### Necessary to compute VMAF value
cd ${vmaf_dir} && source .venv/bin/activate && cd ${curr_dir}

for i in {100..2000..200}
do
# DECODING
ffmpeg -y -i ${dest_dir}/${seq_name}_${i}.${codec} -vcodec rawvideo -f rawvideo ${dest_dir}/${seq_name}_${i}.yuv
# GET BITRATE
bitrate=`grep 'kb/s' ${dest_dir}/encdata_${i}.txt | tail -1 | awk '{print $8}'`
# GET ENCODING TIME
enctime=`./sum_n_get_2-pass_enctime ${dest_dir}/enctime_1st-pass_${i}.txt ${dest_dir}/enctime_2nd-pass_${i}.txt | grep 'User+System_total_time' | awk -F ':' '{print $2}'`
# GET PSNR
psnr=`./psnr_video ${org_seq_name} ${dest_dir}/${seq_name}_${i}.yuv ${w} ${h} ${n}`
# GET VMAF
cd ${vmaf_dir}

(PYTHONPATH=python ${vmaf_dir}/python/vmaf/script/run_vmaf.py \
yuv420p ${w} ${h} \
${curr_dir}/${org_seq_name} \
${curr_dir}/${dest_dir}/${seq_name}_${i}.yuv \
--out-fmt json) &> ${curr_dir}/vmaf.json

cd ${curr_dir}
vmaf=`tail -4 vmaf.json | grep 'score' | awk -F ': ' '{print $2}' | sed -r 's/.{13}$//'`
# WRITE DATA
echo "${encoder_name};${bitrate};${psnr};${vmaf};${enctime}" >> ${output_file}
done

