#!/bin/bash
# STOCKHOLM - HEVC - DECODING (with ffmpeg) AND GET DATA

codec="hevc"
encoder_name="HEVC"
org_seq_name="stockholm_720p.yuv"
seq_name="stockholm"
w=1280
h=720
n=300
fps=60

curr_dir=`pwd`
dest_dir="${codec}_${seq_name}"
output_file="stockholm_720p.csv"
vmaf_dir="/home/ubuntu/vmaf" # Set param with your vmaf path

### Necessary to compute VMAF value
cd ${vmaf_dir} && source .venv/bin/activate && cd ${curr_dir}

decode_n_getdata(){
# DECODING
(/usr/bin/time -o ${dest_dir}/dectime_${i}.txt -f "%U %S %E" ffmpeg -y -i ${dest_dir}/${seq_name}_${i}.${codec} -vcodec rawvideo -f rawvideo ${dest_dir}/${seq_name}_${i}.yuv)
# GET BITRATE
bitrate=`grep 'kb/s' ${dest_dir}/encdata_${i}.txt | tail -1 | awk '{print $8}'`
# GET ENCODING TIME
enctime=`./get_time ${dest_dir}/enctime_${i}.txt min | grep 'User+System_time' | awk -F ':' '{print $2}'`
wallclock=`./get_time ${dest_dir}/enctime_${i}.txt min | grep 'Wall_clock' | awk -F ':' '{print $2}'`
# GET DECODING TIME
dectime=`./get_time ${dest_dir}/dectime_${i}.txt sec | grep 'User+System_time' | awk -F ':' '{print $2}'`
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
echo "${encoder_name};${bitrate};${psnr};${vmaf};${wallclock};${enctime};${dectime}" >> ${output_file}
}

for i in {100..1300..200}
do
    decode_n_getdata
done

for i in {1500..6500..500}
do
    decode_n_getdata
done

