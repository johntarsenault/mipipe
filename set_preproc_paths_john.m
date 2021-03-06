function params = set_preproc_paths_john(preproc_dir)

%'/fmri/spm12_utils:', ...
paths = ['/usr/local/MATLAB/R2017b/toolbox/spm12/:', ...
    '/data/fmri/apps/nx3k_matlab:', ...
    '/usr/local/freesurfer/matlab/:', ...
    genpath(preproc_dir)];

addpath(paths);

params.shell_script_path = fullfile(preproc_dir,'/fmri_preproc_functions/shell_scripts/');
