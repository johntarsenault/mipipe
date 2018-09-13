moveable_anat=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/rois/warp_112_to_dozer/112RM_F99_T1_1mm.nii
coregister_dir=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/rois/warp_112_to_dozer/
moveable_anat_N4=${coregister_dir}112RM_F99_T1_N4.nii
template_anat=/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/template/dozer/dozer_anat.nii

# perform N4 bias correction
$ANTSPATH/N4BiasFieldCorrection -d 3 -i $moveable_anat -o $moveable_anat_N4 -c [100x100x100x100,0] 


antsRegistrationSyN.sh -d 3 -f $template_anat -m $moveable_anat_N4 -t b -o $coregister_dir/syn -n 10 
