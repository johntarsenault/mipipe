function params = preproc_mean_mask_mmds_check(input, params)

%read in 4D image based on input directory and params.preproc_mask.image_no
functional_4D = fullfile(params.base_dir, input.dir, input.file_list{params.image_no});
functional_4D_parts = fileparts_full(functional_4D);

%build mask dir if not already created
mask_dir = fullfile(params.base_dir, '/funct/mask/');
if ~exist(mask_dir)
    mkdir(mask_dir)
end

%% make mean image
functional_mean = fullfile(mask_dir, [functional_4D_parts.file, '_mean', functional_4D_parts.ext]);
system(sprintf('fslmaths %s -Tmean %s >out.log', functional_4D, functional_mean));
functional_mean_part = fullfile(mask_dir, [functional_4D_parts.file, '_mean']);
%% make mask
functional_mask = fullfile(mask_dir, [functional_4D_parts.file, '_brain', functional_4D_parts.ext]);
functional_mask_part = fullfile(mask_dir, [functional_4D_parts.file, '_brain']);

system(sprintf('bet %s %s  -f 0.15 -g 0 -n -m >out.log', functional_mean, functional_mask));

mask_threshold = 0.15;
answer = {mask_threshold};

while(not(isempty(answer)))
    mask_threshold = answer{1};
    fsl_bet_command = sprintf('bet %s %s  -f %0.2f -g 0 -n -m >out.log', functional_mean_part, functional_mask_part,mask_threshold);
    disp(fsl_bet_command);
    system(fsl_bet_command);
    %get name augmented by bet
    functional_mask = fullfile(mask_dir, [functional_4D_parts.file, '_brain_mask', functional_4D_parts.ext]);

    %% view mask and change if necessary
    if params.check_mask
        system(sprintf('/usr/bin/fslview %s %s', functional_mean, functional_mask));
    end
    disp(mask_threshold)
    prompt = sprintf('If mask OK then press cancel\nIf mask size wrong then change threshold\n(smaller values == larger masks)\n current threshold: %0.2f',mask_threshold);
    prompt_cell = {prompt};
    title = 'check mask';
    dims = [1 50];
    definput = {num2str(mask_threshold)};
    answer = inputdlg(prompt_cell,title,dims,definput);
    if not(isempty(answer))
        answer{1}= str2num(answer{1});
    end
end










functional_mean_masked = fullfile(mask_dir, [functional_4D_parts.file, '_masked', functional_4D_parts.ext]);

%% mask mean image
system(sprintf('fslmaths %s -mul %s %s >out.log', functional_mean, functional_mask, functional_mean_masked));

%% dilate mask
fwhm = 1; % size of smoothing kernel in mm.

dilated_image = fullfile(mask_dir, [functional_4D_parts.file, '_masked_dilate', functional_4D_parts.ext]);
cmd1 = sprintf('3dmask_tool -input %s -prefix %s -dilate_input 1 >out.log',functional_mean_masked, dilated_image);
unix(cmd1)

%% smooth mask
dilate_smooth_image = fullfile(mask_dir, [functional_4D_parts.file, '_masked_dilate_smooth', functional_4D_parts.ext]);
cmd2 = sprintf('fslmaths %s -s %d %s >out.log', dilated_image, fwhm, dilate_smooth_image);
unix(cmd2)
    
%% change to nifti
cmd3 = sprintf('fslchfiletype NIFTI %s >out.log', dilate_smooth_image);
unix(cmd3)

%pass mask back in params structure
params.mean_image = functional_mean;
params.mask = functional_mask;
params.mean_image_masked = functional_mean_masked;
params.dilate = dilated_image;
params.dilate_smooth = dilate_smooth_image;

