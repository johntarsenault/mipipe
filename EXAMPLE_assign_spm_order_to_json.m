% Add general paths
mipipe_path = '/data/code/mipipe/';
addpath(genpath(mipipe_path));
addpath('/data/fmri/apps/nx3k_matlab/');

% Determine input folders
pdf_file_name = '/data/examples/fmri/20180425_Datasheets_Scanner_Tank180425.pdf';
nifti_json_dir = '/data/examples/fmri/tank180425/funct/_5_motion_realign_across_runs/';
spm_order_dir = '/data/examples/fmri/tank180425_spm/';

% Determine whether to write fixation data into json files
fixation_option = 1;

% run the scripts
assign_order_file_to_json_all(pdf_file_name, nifti_json_dir, spm_order_dir, fixation_option);