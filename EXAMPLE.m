
preproc_dir = '/data/code/mipipe/';
addpath(preproc_dir);
params = set_preproc_paths_john(preproc_dir);

%specify parameters structure for preprocessing steps
params.base_dir = '/data/examples/fmri/tank180425/';
params.dicom_dir = '/data/examples/fmri/Tank180425_DICOM/';
params.template = '/data/examples/template/tank/tank_anat.nii';

%specify the parameters for analysis
params.tr_no = 450; %# of trs per run
params.image_no = 1; %image number to use for masks
params.smooth.fwhm = 1.5; %fwhm for smoothing

%specify whether to check images
params.check_mask = 0;
params.check_coregister = 1;

%convert dicom to nifti and remove incomplete runs
input = convert_dcm2niix_afni(params.dicom_dir, params.base_dir, params.shell_script_path);
input = cleanup_file_list_using_tr_no(params.base_dir, input, params.tr_no);

%quality assessment
functional_mask = preproc_mask_non_workflow(input, params);
params.image_no = preproc_quality_assessment(input, functional_mask, params);


%define preprocessing steps
step_no_function_pair = {2, 'reorient_sphinx_lsp'; ...
    3, 'slice_timing_afni_alt_z2_preproc'; ...   
    NaN, 'preproc_mean_mask_meanmasked_dilate_smooth'; ...
    4, 'slice_by_slice_lucas_kanade'; ...
    NaN, 'make_mean_target'; ...
    5, 'motion_realign_across_runs'; ...
    NaN, 'preproc_mean_mask_meanmasked'; ...
    NaN, 'coregister_ants_preproc'; ...
    6, 'apply_coregister_4D_ants_preproc'; ...
    7,'fsl_smooth_preproc'};

%single image workflow
tic
    workflow = loop_workflow_steps(step_no_function_pair,input,params);
toc