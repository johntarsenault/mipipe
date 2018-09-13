function params = preproc_mask_masked_gre(input, params)

%build mask dir if not already created
mask_dir = fullfile(params.base_dir, '/funct/mask/');
if ~exist(mask_dir)
    mkdir(mask_dir)
end


gre_parts = fileparts_full(params.gre);

gre_mask = fullfile(mask_dir, [gre_parts.file, '_gre_brain', gre_parts.ext]);
system(sprintf('bet %s %s  -f 0.28 -g 0 -n -m', params.gre, gre_mask));
gre_mask = fullfile(mask_dir, [gre_parts.file, '_gre_brain_mask', gre_parts.ext]);

system(sprintf('/usr/bin/fslview %s %s', params.gre, gre_mask));

gre_masked = fullfile(mask_dir, [gre_parts.file, '_gre_masked', gre_parts.ext]);

%mask mean image
system(sprintf('fslmaths %s -mul %s %s', params.gre, gre_mask, gre_masked));


%pass gre mask back in params structure
params.gre_masked = gre_masked;

