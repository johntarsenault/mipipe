input_file=$1
output_file=$2

expected_orientation='LSP'

orientation_val=$(mri_info $input_file | grep Orientation | cut -c16-19)

if [ $orientation_val == $expected_orientation ] 
then
	mri_convert -i $input_file --in_orientation RPS  -o $output_file
else
	echo 'failed! file orientation: ' $orientation_val ' not expected orientation: ' $expected_orientation
fi


