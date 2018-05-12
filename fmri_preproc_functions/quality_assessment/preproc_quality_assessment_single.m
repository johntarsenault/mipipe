function  preproc_quality_assessment_single(input_file, output_file_mean, output_file_std, output_file_tsnr, output_file_mean_tsnr, functional_mask)

%calculate mean
unix_command = sprintf('fslmaths %s -Tmean %s',input_file,output_file_mean);
system(unix_command);

%calculate std
unix_command = sprintf('fslmaths %s -Tstd %s',input_file,output_file_std);
system(unix_command);

%calculate tsnr
unix_command = sprintf('fslmaths %s -div %s %s',output_file_mean,output_file_std,output_file_tsnr);
system(unix_command);



%calculate mean tsnr in mask
unix_command = sprintf('fslstats %s -k %s -m >> %s',output_file_tsnr,functional_mask,output_file_mean_tsnr);
system(unix_command);

