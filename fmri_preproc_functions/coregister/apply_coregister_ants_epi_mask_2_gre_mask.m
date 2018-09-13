function params = apply_coregister_ants_epi_mask_2_gre_mask(input, params)

mask_dir = fullfile(params.base_dir, '/funct/mask/');
gre_parts = fileparts_full(params.gre);
params.gre_mask = fullfile(mask_dir, [gre_parts.file, '_gre_brain_mask', gre_parts.ext]);

input_file = params.mask;
output_file = params.gre_mask;

unix_command = sprintf('antsApplyTransforms --default-value 0 --dimensionality 3 -e 3 -i %s --interpolation NearestNeighbor -o %s --reference-image %s --transform [%s,0] >out.log', input_file, output_file, params.gre_reorient, params.affine_transform_fmri_2_gre_mask);
system(unix_command);

system(sprintf('/usr/bin/fslview %s %s', params.gre_reorient, params.gre_mask));

%mask mean image
gre_masked = fullfile(mask_dir, [gre_parts.file, '_gre_masked', gre_parts.ext]);
system(sprintf('fslmaths %s -mul %s %s', params.gre_reorient, params.gre_mask, gre_masked));


%pass gre mask back in params structure
params.gre_masked = gre_masked;
