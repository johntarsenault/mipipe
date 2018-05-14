function preproc_function = get_preproc_functions(function_name)

switch function_name
    
    case 'reorient_sphinx_lsp'
        preproc_function.function_call = @reorient_sphinx_lsp;
        preproc_function.function_name = 'reorient_sphinx_lsp';
        preproc_function.function_description = 'reorients image acquired in sphinx position, HeadFirstProne orientation and correctly labelled as LSP';
        preproc_function.prefix = 'r';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 1;
        
    case 'slice_timing'
        preproc_function.function_call = @slice_timing_preproc;
        preproc_function.function_name = 'slice_timing';
        preproc_function.function_description = 'slice timing correction -using slice timing info from BIDS sidecare and spm12 slice timing to correct to middle timepoint acquired';
        preproc_function.prefix = 'st';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 1;
        
    case 'slice_timing_afni_alt_z2_preproc'
        preproc_function.function_call = @slice_timing_afni_alt_z2_preproc;
        preproc_function.function_name = 'slice_timing_afni_alt_z2_preproc';
        preproc_function.function_description = 'slice timing correction using afni with timing set to alt+z2';
        preproc_function.prefix = 'st';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 1;
        
    case 'slice_by_slice_within_run'
        % requires:
        % params.mask = '/path/to/*_brain_mask.nii
        preproc_function.function_call = @slice_by_slice_within_run;
        preproc_function.function_name = 'slice_by_slice_within_run';
        preproc_function.function_description = 'slice by slice motion realignment within a run: in-house hauke, dante, wouter';
        preproc_function.prefix = 'u';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 1;
        preproc_function.is_each_image_processed = 1;
        
    case 'make_mean_target'
        % requires:
        % params.image_no = 5; determines which image to make target from 
        % creates:
        % params.mean_target
        preproc_function.function_call = @make_mean_target;
        preproc_function.function_name = 'make_mean_target';
        preproc_function.function_description = 'motion realignment across runs';
        preproc_function.prefix = '';
        preproc_function.is_directory_created = 0;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 0;
        
    case 'motion_realign_across_runs'
        %requires:
        %params.mean_target = '/path/to/mean_target.nii
        preproc_function.function_call = @motion_realign_across_runs;
        preproc_function.function_name = 'motion_realign_across_runs';
        preproc_function.function_description = 'affine motion realignment across differnet runs';
        preproc_function.prefix = 'mr';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 1;
                
    case 'fsl_smooth_preproc'
        %requires:
        %params.smooth.fwhm = 1.5; fwhm of smoothing in mm
        preproc_function.function_call = @fsl_smooth_preproc;
        preproc_function.function_name = 'fsl_smooth_preproc';
        preproc_function.function_description = 'smooths each images with a fwhm (mm) kernel';
        preproc_function.prefix = 's';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 1;
        
    case 'preproc_mask'
        %requires:
        %params.make_mean_target.image_no = 1; image number to start make a
        %mask from
        preproc_function.function_call = @preproc_mask;
        preproc_function.function_name = 'preproc_mask';
        preproc_function.function_description = 'generates a mask for motion realigment and quality assessment';
        preproc_function.prefix = '';
        preproc_function.is_directory_created = 0;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 0;
        
    case 'preproc_mean_mask_meanmasked'
        %requires:
        %params.preproc_mask.image_no = 1
        %image number to start make a mask from
        preproc_function.function_call = @preproc_mean_mask_meanmasked;
        preproc_function.function_name = 'preproc_mean_mask_meanmasked';
        preproc_function.function_description = 'generates a mean image, mask of mean image, and a masked mean image';
        preproc_function.prefix = '';
        preproc_function.is_directory_created = 0;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 0;
        
    case 'preproc_mean_mask_meanmasked_dilate_smooth'
        preproc_function.function_call = @preproc_mean_mask_meanmasked_dilate_smooth;
        preproc_function.function_name = 'preproc_mean_mask_meanmasked_dilate_smooth';
        preproc_function.function_description = 'generates a mean image, mask of mean image, masked mean image, dilate mask and smooth mask';
        preproc_function.prefix = '';
        preproc_function.is_directory_created = 0;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 0;
        
    case 'preproc_mask_mean_target'
        preproc_function.function_call = @preproc_mask_mean_target;
        preproc_function.function_name = 'preproc_mask_mean_target';
        preproc_function.function_description = 'mask target image';
        preproc_function.prefix = '';
        preproc_function.is_directory_created = 0;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 0;
        
    case 'apply_coregister_4D_ants_preproc'
        % requires:
        % params.template = '/path/to/monkey_anat.nii';
        % params.b_spline_warp_transform; created in 'coregister_ants_preproc'
        % params.affine_transform; created in 'coregister_ants_preproc'
        preproc_function.function_call = @apply_coregister_4D_ants_preproc;
        preproc_function.function_name = 'apply_coregister_4D_ants_preproc';
        preproc_function.function_description = 'applies ants coregistration on 4D data';
        preproc_function.prefix = 'nr';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 1;
        
    case 'coregister_ants_preproc'
        % requires:
        % params.mean_image_masked = '/path/to/mean_image_masked.nii';
        % creates: 
        % params.affine_transform
        % params.b_spline_warp_transform
        preproc_function.function_call = @coregister_ants_preproc;
        preproc_function.function_name = 'coregister_ants_preproc';
        preproc_function.function_description = 'runs ANTS rigid + affine + deformable b-spline syn coregistration for a single image';
        preproc_function.prefix = '';
        preproc_function.is_directory_created = 0;
        preproc_function.is_regressor_created = 0;
        preproc_function.is_each_image_processed = 0;
        
    case 'slice_by_slice_lucas_kanade'
        % requires:
        % params.dilate_smooth = '/path/to/dilate_smooth.nii';
        preproc_function.function_call = @slice_by_slice_lucas_kanade;
        preproc_function.function_name = 'slice_by_slice_lucas_kanade';
        preproc_function.function_description = 'runs slice by slice lucas kanade motion realignment';
        preproc_function.prefix = 'k';
        preproc_function.is_directory_created = 1;
        preproc_function.is_regressor_created = 1;
        preproc_function.is_each_image_processed = 1;
        
    otherwise
        error('the preproc function your trying to call doesn''t exit');
end