function fslmaths_tmean(input_file,output_file)

command_line_function_call = sprintf('fslmaths %s -Tmean %s', input_file,output_file);
system(command_line_function_call);

