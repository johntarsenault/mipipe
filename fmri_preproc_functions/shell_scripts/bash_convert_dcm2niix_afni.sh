dicom_dir=$1
output_dir=$2

#convert DICOM 2 nifti and grab filename of nifti image
OUTPUT="$(dcm2niix -o $output_dir -b y $dicom_dir | grep Convert | awk '{print $5}')"
output_file_name=$(basename $OUTPUT)
output_full_file_name=${output_file_name}'.nii'

#save filename to file_list
echo -e $output_full_file_name"\n" >> ${output_dir}file_list.txt
