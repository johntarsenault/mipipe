input_file=$1
output_file=$2
in_orientation=$3
out_orientation=$4

expected_orientation=$in_orientation

orientation_val=$(mri_info $input_file | grep Orientation | cut -c16-19)

if [ $orientation_val == $expected_orientation ] 
then
	mri_convert -i $input_file --in_orientation $out_orientation  -o $output_file
else
	echo 'failed! file orientation: ' $orientation_val ' not expected orientation: ' $expected_orientation
fi


