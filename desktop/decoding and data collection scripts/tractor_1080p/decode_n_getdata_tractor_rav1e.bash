#!/bin/bash
# TRACTOR - RAV1E - DECODING AND GET DATA

codec="av1"
encoder_name="RAV1E"
org_seq_name="tractor_1080p.yuv"
seq_name="tractor"
w=1920
h=1080
n=300
fps=25

curr_dir=`pwd`
dest_dir="${encoder_name}_${seq_name}"
output_file="tractor_1080p.csv"
vmaf_dir="/home/ubuntu/vmaf" # Set param with your vmaf path
dav1d_path="/home/ubuntu/dav1d/build/tools/dav1d" # Set param with your dav1d path
svtav1_path="/home/ubuntu/svtav1" # Set param with your SVT-AV1 path
gav1_path="/home/ubuntu/libgav1/build/gav1_decode" # Set param with your GAV1 path

### Necessary to compute VMAF value
cd ${vmaf_dir} && source .venv/bin/activate && cd ${curr_dir}

decode_n_getdata(){
# DECODING
(/usr/bin/time -o ${dest_dir}/dectime_${i}.txt -f "%U %S %E" ffmpeg -y -i ${dest_dir}/${seq_name}_${i}.ivf -vcodec rawvideo -f rawvideo ${dest_dir}/${seq_name}_${i}.yuv)
# GET BITRATE
bitrate=`grep 'Kb/s' ${dest_dir}/encdata_${i}.txt | tail -c 100 | awk -F 'fps, ' '{print $2}' | awk -F ' Kb/s' '{print $1}'`
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
# GET DAV1D DECODING TIME
(/usr/bin/time -o ${dest_dir}/dectime_dav1d.txt -f "%U %S %E" ${dav1d_path} -i ${dest_dir}/${seq_name}_${i}.ivf -o /dev/null)
dav1d_dectime=`./get_time ${dest_dir}/dectime_dav1d.txt sec | grep 'User+System_time' | awk -F ':' '{print $2}'`
# GET SVT-AV1 DECODING TIME
cd ${svtav1_path}

/usr/bin/time -o ${curr_dir}/${dest_dir}/dectime_svtav1.txt -f "%U %S %E" ./SvtAv1DecApp -i ${curr_dir}/${dest_dir}/${seq_name}_${i}.ivf -o /dev/null

cd ${curr_dir}

svtav1_dectime=`./get_time ${dest_dir}/dectime_svtav1.txt sec | grep 'User+System_time' | awk -F ':' '{print $2}'`
# GET GAV1 DECODING TIME
/usr/bin/time -o ${dest_dir}/dectime_gav1.txt -f "%U %S %E" ${gav1_path} ${dest_dir}/${seq_name}_${i}.ivf
gav1_dectime=`./get_time ${dest_dir}/dectime_gav1.txt sec | grep 'User+System_time' | awk -F ':' '{print $2}'`
# WRITE DATA
echo "${encoder_name};${bitrate};${psnr};${vmaf};${wallclock};${enctime};${dectime};${dav1d_dectime};${svtav1_dectime};${gav1_dectime}" >> ${output_file}
}

for i in {300..1100..200}
do
    decode_n_getdata
done

for i in {1400..5000..300}
do
    decode_n_getdata
done
