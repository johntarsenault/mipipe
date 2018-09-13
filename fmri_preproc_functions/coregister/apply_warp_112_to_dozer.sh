input_dir=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/rois/orig/corrected_dims/
input_file_only=F99_D99_rois_rh_1mm.nii
input_file=${input_dir}${input_file_only}

output_dir=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/rois/
output_file=${output_dir}warp_dozer_${input_file_only}

coregister_dir=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/rois/warp_112_to_dozer/
params_template=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/template/dozer/dozer_anat.nii
params_b_spline_warp_transform=syn1Warp.nii.gz
params_affine_transform=syn0GenericAffine.mat

antsApplyTransforms --default-value 0 --dimensionality 3 -e 3 -i $input_file --interpolation NearestNeighbor -o $output_file  --reference-image $params_template  --transform $params_b_spline_warp_transform --transform [$params_affine_transform,0] >out.log

