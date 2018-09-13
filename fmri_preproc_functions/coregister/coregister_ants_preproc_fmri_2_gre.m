function params = coregister_ants_preproc_fmri_2_gre_2_anat(input, params)


%make a coregister dir to hold outputs of ants registration
coregister_dir = fullfile(params.base_dir, '/funct/coregister_template/');
if ~exist(coregister_dir)
    mkdir(coregister_dir)
end

%% step 1 run antsRegistrationSyN.sh fMRI to gre

%perform ants registration fmri -> gre
unix_command = sprintf('antsRegistrationSyN.sh -d 3 -f %s -m %s -t t -o %s/syn_fmri_2_gre_mask -n 10 > out.log', params.gre_reorient, params.mean_image, coregister_dir);
system(unix_command);

params.affine_transform_fmri_2_gre_mask = [coregister_dir, 'syn_fmri_2_gre_mask0GenericAffine.mat'];
params.b_spline_warp_transform_fmri_2_gre_mask = [coregister_dir, 'syn_fmri_2_gre_maskWarp.nii.gz'];
params.template_gre_mask = params.mean_image_masked;
