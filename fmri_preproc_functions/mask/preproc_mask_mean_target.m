function params = preproc_mask_mean_target(input, params)

%read in 4D image based on input directory and params.preproc_mask.image_no
mean_target_parts = fileparts_full(params.mean_target);

%build mask dir if not already created
mask_dir = fullfile(params.base_dir, '/funct/mask/');
if ~exist(mask_dir)
    mkdir(mask_dir)
end

%create name of mean_target_masked
mean_target_masked = fullfile(mask_dir,[mean_target_parts.file, '_masked', mean_target_parts.ext]);

%mask mean image
system(sprintf('fslmaths %s -mul %s %s >out.log', params.mean_target, params.mask, mean_target_masked));


params.mean_image_masked = mean_target_masked;
