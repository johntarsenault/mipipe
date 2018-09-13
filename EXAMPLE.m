%% Initial step: loading in images, quality check
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

% convert dicom to nifti and remove incomplete runs
input = convert_dcm2niix_afni(params.dicom_dir, params.base_dir, params.shell_script_path);
input = cleanup_file_list_using_tr_no(params.base_dir, input, params.tr_no);

% quality assessment
functional_mask = preproc_mask_non_workflow(input, params);
params.image_no = preproc_quality_assessment(input, functional_mask, params);

% remove bad images after quality assessment 
%[input, params] = remove_outlier_runs(runs2remove, input, params);

% define preprocessing steps
step_no_function_pair = {2, 'reorient_sphinx_lsp'; ...
    3, 'slice_timing_afni_alt_z2_preproc'; ...
    NaN, 'preproc_mean_mask_meanmasked_dilate_smooth'; ...
    4, 'slice_by_slice_within_run'; ...
    NaN, 'make_mean_target'; ...
    5, 'motion_realign_across_runs'; ...
    NaN, 'preproc_mask_mean_target'; ...
    NaN, 'preproc_combine_gre'; ...
    NaN, 'preproc_mask_masked_gre'; ...
    NaN, 'reorient_sphinx_single_gre'; ...
    NaN, 'coregister_ants_preproc_fmri_2_gre_2_anat'; ...
    6, 'apply_coregister_4D_ants_preproc_fmri_2_gre_2_anat'; ...
    7, 'fsl_smooth_preproc'};

%single image workflow
tic
    workflow = loop_workflow_steps(step_no_function_pair,input,params);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% re-run crashed analysis 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
base_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180426_test/';
start_step = 7;
re_run_workflow(base_dir, start_step)