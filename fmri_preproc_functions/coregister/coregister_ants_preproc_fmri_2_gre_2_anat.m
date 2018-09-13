function params = coregister_ants_preproc_fmri_2_gre_2_anat(input, params)


%make a coregister dir to hold outputs of ants registration
coregister_dir = fullfile(params.base_dir, '/funct/coregister_template/');
if ~exist(coregister_dir)
    mkdir(coregister_dir)
end

%% step 1 run antsRegistrationSyN.sh fMRI to gre

%perform ants registration fmri -> gre
unix_command = sprintf('antsRegistrationSyN.sh -d 3 -f %s -m %s -t b -o %s/syn_fmri_2_gre -n 10 > out.log', params.gre_reorient, params.mean_image_masked, coregister_dir);
system(unix_command);

params.affine_transform_fmri_2_gre = [coregister_dir, 'syn_fmri_2_gre0GenericAffine.mat'];
params.b_spline_warp_transform_fmri_2_gre = [coregister_dir, 'syn_fmri_2_gre1Warp.nii.gz'];

%% step 2 run antsRegistrationSyN.sh gre to anatomy

%build name of N4 bias corrected image
gre_image_parts = fileparts_full(params.gre_reorient);
gre_image_n4 = fullfile(coregister_dir, [gre_image_parts.file, '_n4_bias_correct', gre_image_parts.ext]);

%perform N4 bias correction
unix_command = sprintf('$ANTSPATH/N4BiasFieldCorrection -d 3 -i %s -o %s -c [100x100x100x100,0] > out.log', params.gre_reorient, gre_image_n4);
system(unix_command);

%perform ants registration anatomical -> epi
unix_command = sprintf('antsRegistrationSyN.sh -d 3 -f %s -m %s -t b -o %s/syn_gre_2_anat -n 10 > out.log', params.template, gre_image_n4, coregister_dir);
system(unix_command);

params.affine_transform_gre_2_anat = [coregister_dir, 'syn_gre_2_anat0GenericAffine.mat'];
params.b_spline_warp_transform_gre_2_anat = [coregister_dir, 'syn_gre_2_anat1Warp.nii.gz'];


if params.check_coregister
    %view coregistration fMRI to gre
    system(sprintf('/usr/bin/fslview %s %s', params.gre_reorient, [coregister_dir, 'syn_fmri_2_greWarped.nii.gz']));

    %view coregistration gre to anat
    system(sprintf('/usr/bin/fslview %s %s', params.template, [coregister_dir, 'syn_gre_2_anatWarped.nii.gz']));
end