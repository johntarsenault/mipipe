function slice_timing_afni_alt_z2_preproc(input_file, output_file, params)

output_file_parts = fileparts_full(output_file);

afni_base_name = [output_file_parts.path, output_file_parts.file];

unix_command_call = sprintf('3dTshift -tzero 1 -tpattern alt+z2 -quintic -prefix %s %s', afni_base_name, input_file);
system(unix_command_call);

afni_full_name_BRIK = [afni_base_name, '+orig.BRIK'];
afni_full_name_HEAD = [afni_base_name, '+orig.HEAD'];


unix_command_call = sprintf('mri_convert -i %s -o %s', afni_full_name_BRIK, output_file);
system(unix_command_call)

delete(afni_full_name_BRIK);
delete(afni_full_name_HEAD);
