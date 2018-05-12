function input = grab_input_file_list_from_dir(input,params)

nifti_dir= dir([params.base_dir, input.dir,'*.nii']);
input.file_list = {nifti_dir.name};

