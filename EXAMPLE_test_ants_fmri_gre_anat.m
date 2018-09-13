
preproc_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/mipipe/';
addpath(preproc_dir);
params = set_preproc_paths(preproc_dir);

params.check_coregister = 1;
params.base_dir = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180606_test/';
params.gre_reorient = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180606_test/funct/gre_dir/Tank180606_4avg_GRE_masked_RIA.nii';
params.mean_image_masked = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180606_test/funct/mask/Tank180606_IMA_24_r_st_u_mean_target_masked.nii';
params.template = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/template/tank/tank_anat.nii';
input.dir = '/funct/_5_motion_realign_across_runs/';

input = grab_input_file_list_from_dir(input,params);

%define preprocessing steps
step_no_function_pair = {NaN, 'coregister_ants_preproc_fmri_2_gre_2_anat'; ...
    6,'apply_coregister_4D_ants_preproc_fmri_2_gre_2_anat'};

%single image workflow
tic
    workflow = loop_workflow_steps(step_no_function_pair,input,params);
toc