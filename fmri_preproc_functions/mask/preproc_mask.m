function params = preproc_mask(input, params)

%read in 4D image based on input directory and params.preproc_mask.image_no
functional_4D = [params.base_dir, input.dir, input.file_list{params.image_no}];
functional_4D_parts = fileparts_full(functional_4D);

%build mask dir if not already created
mask_dir = fullfile(params.base_dir, '/funct/mask/');
if ~exist(mask_dir)
    mkdir(mask_dir)
end

%make mean image
functional_mean = [mask_dir, functional_4D_parts.file, '_mean', functional_4D_parts.ext];
system(sprintf('/fmri/apps/fsl-5.0.0/bin/fslmaths %s -Tmean %s', functional_4D, functional_mean));

%make mask
functional_mask = [mask_dir, functional_4D_parts.file, '_brain_mask', functional_4D_parts.ext];
system(sprintf('/fmri/apps/fsl-5.0.0/bin/bet %s %s  -f 0.15 -g 0 -n -m', functional_mean, functional_mask));


%view mask and change if necessary
if params.check_mask
    system(sprintf('/usr/bin/fslview %s %s', functional_mean, functional_mask));
end

%pass mask back in params structure
params.mask = functional_mask;
