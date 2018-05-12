
preproc_dir = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/fmri_preproc/';
addpath(preproc_dir);
params = set_preproc_paths(preproc_dir);

%specify parameters structure for preprocessing steps
params.base_dir = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180423/dante_slicebyslice/';
params.dicom_dir = '/data/fmri_archive_01/RAW/Tank/Tank180423_DICOM/MONKEY_FUNCTIONAL_20180423_141248_916000/';
params.template = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/template/tank/tank_anat.nii';

%specify the parameters for analysis
params.tr_no = 450;
params.check_mask = 0;
params.image_no = 1;
params.smooth.fwhm = 1.5;

%convert dicom to nifti and remove incomplete runs
input = convert_dcm2niix_afni(params.dicom_dir, params.base_dir, params.shell_script_path);
input = cleanup_file_list_using_tr_no(params.base_dir, input, params.tr_no);

%quality assessment
functional_mask = preproc_mask_non_workflow(input, params);
params.image_no = preproc_quality_assessment(input, functional_mask, params);

%single image workflow

%define preprocessing steps
step_no_function_pair = {2, 'reorient_sphinx_lsp'; ...
    NaN,'preproc_mask'; ...
    3, 'slice_timing_afni_alt_z2_preproc'; ...   
    NaN, 'preproc_mean_mask_meanmasked'; ...
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


input.dir = 

%766.101533 seconds for 1 run - 450 volumes
%2163.833010 seconds for 11 runs - 450 volumes