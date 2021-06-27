#!/bin/bash

seq_name="elephants_dream"
output_file="${seq_name}_2-pass_480p.csv"

echo '"Encoder Type";"Bitrate [kbps]";"PSNR [dB]";"VMAF";"Enc time [min]"' >> ${output_file}

chmod +x decode_2-pass_n_getdata_${seq_name}_h264.bash && ./decode_2-pass_n_getdata_${seq_name}_h264.bash
chmod +x decode_2-pass_n_getdata_${seq_name}_hevc.bash && ./decode_2-pass_n_getdata_${seq_name}_hevc.bash
chmod +x decode_2-pass_n_getdata_${seq_name}_aom.bash && ./decode_2-pass_n_getdata_${seq_name}_aom.bash
chmod +x decode_2-pass_n_getdata_${seq_name}_svtav1.bash && ./decode_2-pass_n_getdata_${seq_name}_svtav1.bash
