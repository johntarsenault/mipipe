function params = coregister_ants_preproc(input, params)

%make a coregister dir to hold outputs of ants registration
coregister_dir = fullfile(params.base_dir, '/funct/coregister_template/');
if ~exist(coregister_dir)
    mkdir(coregister_dir)
end

%build name of N4 bias corrected image
mean_image_parts = fileparts_full(params.mean_image_masked);
mean_image_n4 = fullfile(coregister_dir, [mean_image_parts.file, '_n4_bias_correct', mean_image_parts.ext]);

%perform N4 bias correction
unix_command = sprintf('$ANTSPATH/N4BiasFieldCorrection -d 3 -i %s -o %s -c [100x100x100x100,0] > out.log', params.mean_image_masked, mean_image_n4);
system(unix_command);

%perform ants registration anatomical -> epi
unix_command = sprintf('antsRegistrationSyN.sh -d 3 -f %s -m %s -t b -o %s/syn -n 10 > out.log', params.template, mean_image_n4, coregister_dir);
system(unix_command);

params.affine_transform = [coregister_dir, 'syn0GenericAffine.mat'];
params.b_spline_warp_transform = [coregister_dir, 'syn1Warp.nii.gz'];


if params.check_coregister
    %view mask and change if necessary
    system(sprintf('/usr/bin/fslview %s %s', params.template, [coregister_dir, 'synWarped.nii.gz']));
end