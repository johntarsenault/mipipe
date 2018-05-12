function fslmaths_add1(input_file,output_file)

command_line_function_call = sprintf('fslmaths %s -add 1 %s', input_file,output_file);
system(command_line_function_call);
