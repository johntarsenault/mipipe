function smooth_json_data = fsl_smooth_preproc(input_file, output_file, params)

sigma = params.smooth.fwhm / 2.355;

unix_command = sprintf('fslmaths %s  -s %0.6f  %s >out.log', input_file, params.smooth.fwhm, output_file);
system(unix_command);

smooth_json_data = {'smooth_fwhm', params.smooth.fwhm};
