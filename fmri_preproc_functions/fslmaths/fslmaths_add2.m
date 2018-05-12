function fslmaths_add2(input_file,output_file)

command_line_function_call = sprintf('fslmaths %s -add 2 %s', input_file,output_file);
system(command_line_function_call);
