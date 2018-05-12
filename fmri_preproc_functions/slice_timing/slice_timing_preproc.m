function slice_timing_preproc(input_file,output_file, params)

nii_slice_time(input_file);

[input_path, input_file,input_ext] = fileparts(input_file);


movefile([input_path,'/st_', input_file,input_ext],output_file);