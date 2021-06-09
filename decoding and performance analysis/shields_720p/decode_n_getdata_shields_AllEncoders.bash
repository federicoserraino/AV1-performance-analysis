#!/bin/bash

seq_name="shields"
output_file="${seq_name}_720p.csv"

echo '"Encoder Type";"Bitrate [kbps]";"PSNR [dB]";"VMAF";"Enc wall-clock [min]";"Enc time [min]";"Dec time (ffmpeg) [sec]";"Dec time (dAV1d) [sec]";"Dec time (SVT-AV1) [sec]";"Dec time (GAV1) [sec]"' >> ${output_file}

chmod +x decode_n_getdata_${seq_name}_h264.bash && ./decode_n_getdata_${seq_name}_h264.bash
chmod +x decode_n_getdata_${seq_name}_hevc.bash && ./decode_n_getdata_${seq_name}_hevc.bash
chmod +x decode_n_getdata_${seq_name}_aom.bash && ./decode_n_getdata_${seq_name}_aom.bash
chmod +x decode_n_getdata_${seq_name}_svtav1.bash && ./decode_n_getdata_${seq_name}_svtav1.bash
chmod +x decode_n_getdata_${seq_name}_rav1e.bash && ./decode_n_getdata_${seq_name}_rav1e.bash
