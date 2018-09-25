function output = convert_dcm2niix_afni(dicom_dir, base_dir,shell_script_path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
output_ep2d_dir = fullfile(base_dir, '/funct/_0_source_data/');
output.dir = '/funct/_0_source_data/';

if exist(fullfile(output_ep2d_dir,'file_list.txt'))
    delete(fullfile(output_ep2d_dir,'file_list.txt'));
end

%make output_dir if it doesn't exist
if ~exist(output_ep2d_dir)
    mkdir(output_ep2d_dir);
end

ep2d_dirs = dir(fullfile(dicom_dir, 'EP2D*'));
ep2d_dirs(find([ep2d_dirs.isdir] == 0)) = [];

for i_ep2d_dirs = 1:numel(ep2d_dirs)
    current_ep2d_dirs = [ep2d_dirs(i_ep2d_dirs).folder,'/', ep2d_dirs(i_ep2d_dirs).name, '/'];
    command_line_function_call = sprintf('bash %sbash_convert_dcm2niix_afni.sh %s %s >out.log', shell_script_path, current_ep2d_dirs, output_ep2d_dir);
    system(command_line_function_call);
end

%% read in nifti files and generate a list of epi images 

nifti_in_dir = dir([output_ep2d_dir,'*.nii']);

for i_images = 1:numel(nifti_in_dir)
            output.file_list{i_images} = nifti_in_dir(i_images).name;
end
    
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_gre_3d_dir = fullfile(base_dir, '/funct/_0_source_data/gre_3d/');

%make output_gre_3d_dir if it doesn't exist
if ~exist(output_gre_3d_dir)
    mkdir(output_gre_3d_dir);
end

gre_3d_dirs = dir(fullfile(dicom_dir, 'GRE_3D*'));
gre_3d_dirs(find([gre_3d_dirs.isdir] == 0)) = [];

for i_gre_3d_dirs = 1:numel(gre_3d_dirs)
    current_gre_3d_dirs = [gre_3d_dirs(i_gre_3d_dirs).folder,'/', gre_3d_dirs(i_gre_3d_dirs).name, '/'];
    command_line_function_call = sprintf('bash %sbash_convert_dcm2niix_afni.sh %s %s >out.log', shell_script_path, current_gre_3d_dirs, output_gre_3d_dir);
    system(command_line_function_call);
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_gre_fm_dir = fullfile(base_dir, '/funct/_0_source_data/gre_fm/');

%make output_gre_3d_dir if it doesn't exist
if ~exist(output_gre_fm_dir)
    mkdir(output_gre_fm_dir);
end

gre_fm_dirs = dir(fullfile(dicom_dir, 'GRE_FM*'));
gre_fm_dirs(find([gre_fm_dirs.isdir] == 0)) = [];

for i_gre_fm_dirs = 1:numel(gre_fm_dirs)
    current_gre_fm_dirs = [gre_fm_dirs(i_gre_fm_dirs).folder,'/', gre_fm_dirs(i_gre_fm_dirs).name, '/'];
    command_line_function_call = sprintf('bash %sbash_convert_dcm2niix_afni.sh %s %s >out.log', shell_script_path, current_gre_fm_dirs, output_gre_fm_dir);
    system(command_line_function_call);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    