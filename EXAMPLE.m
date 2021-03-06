%% step one: initialize parameters for analysis, convert DICOM(*.ima) to NIFTI(*.nii) and JSON(*.json) 
preproc_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/mipipe/';
addpath(preproc_dir);
params = set_preproc_paths(preproc_dir);

% specify parameters structure for preprocessing steps
params.base_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180426_test/';
params.dicom_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/Tank180426_DICOM/';
params.template = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/template/tank/tank_anat.nii';

% specify the parameters for analysis
params.tr_no = 450; %# of trs per run
params.image_no = 1; %image number to use for masks
params.smooth.fwhm = 1.5; %fwhm for smoothing

%specify gre parameters
params.gre_dir = '/funct/_0_source_data/gre_3d/'; %location where gre are stored
params.gre_in_orientation = 'RAS';
params.gre_out_orientation = 'RIA';

% specify whether to check images
params.check_mask = 1;
params.check_coregister = 1;

% convert dicom to nifti 
input = convert_dcm2niix_afni(params.dicom_dir, params.base_dir, params.shell_script_path);

%% step two: remove incomplete fmri runs
input = cleanup_file_list_using_tr_no(params.base_dir, input, params.tr_no);

%% step three: check data quality
% quality assessment
functional_mask = preproc_mask_non_workflow(input, params);
params.image_no = preproc_quality_assessment(input, functional_mask, params);

%% step four (optional): remove bad runs if found
% remove bad images after quality assessment 
%[input, params] = remove_outlier_runs(runs2remove, input, params);

%% step five: run pre-processing

% define preprocessing steps
step_no_function_pair = {
    2, 'reorient_sphinx_lsp'; ...                               % 1: reorient fmri images
    3, 'slice_timing_afni_alt_z2_preproc'; ...                  % 2: slice timing
    NaN, 'preproc_mean_mask_mmds_check'; ...                    % 3: make a mean image and a mask; then gives you chance to edit mask
    4, 'slice_by_slice_lucas_kanade'; ...                       % 4: slice by slice coregistration within run
    NaN, 'make_mean_target'; ...                                % 5: mean of all fmri data
    5, 'motion_realign_across_runs'; ...                        % 6: realign each run to a template
    NaN, 'preproc_mask_mean_target'; ...                        % 7: mean and mask realigned fmri images
    NaN, 'preproc_combine_gre'; ...                             % 8: determine which gre image and combine
    NaN, 'reorient_sphinx_single_gre_unmasked'; ...             % 9: reorient gre
    NaN, 'coregister_ants_preproc_fmri_2_gre'; ...              % 10: coregister gre to fmri;
    NaN, 'apply_coregister_ants_epi_mask_2_gre_mask'; ...       % 11: applies coregistration to mask; then gives you chance to edit mask
    NaN, 'coregister_ants_preproc_fmri_2_gre_2_anat'; ...       % 12: coregister fmri to gre to anat;
    6, 'apply_coregister_4D_ants_preproc_fmri_2_gre_2_anat'; ...% 13: applies coregistration to fmri data
    7, 'fsl_smooth_preproc'};                                   % 14: smooths fmri data

%run workflow
tic
    workflow = loop_workflow_steps(step_no_function_pair,input,params);
toc

%% step six (optional): re-run pre-processing if crashed
base_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180426_test/';
start_step = 3;
re_run_workflow(base_dir, start_step)