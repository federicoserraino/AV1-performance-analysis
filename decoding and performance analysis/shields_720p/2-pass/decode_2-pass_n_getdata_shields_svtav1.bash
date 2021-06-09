#!/bin/bash
# SHIELDS - SVT_AV1 - TWO PASS DECODING AND GET DATA

codec="av1"
encoder_name="SVTAV1"
org_seq_name="shields_720p.yuv"
seq_name="shields_2-pass"
w=1280
h=720
n=300
fps=50

curr_dir=`pwd`
dest_dir="${encoder_name}_${seq_name}"
output_file="shields_2-pass_720p.csv"
vmaf_dir="/home/ubuntu/vmaf" # Set param with your vmaf path

### Necessary to compute VMAF value
cd ${vmaf_dir} && source .venv/bin/activate && cd ${curr_dir}

for i in {100..2000..200}
do
# DECODING
ffmpeg -y -i ${dest_dir}/${seq_name}_${i}.${codec} -vcodec rawvideo -f rawvideo ${dest_dir}/${seq_name}_${i}.yuv
# GET BITRATE
bitrate=`grep 'kbps' ${dest_dir}/encdata_${i}.txt | tail -1 | awk '{print $5}'`
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
