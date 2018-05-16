function [mean_median_distance_index mean_outlier_detection]  = preproc_quality_assessment_single(input_file, output_file_mean, output_file_std, output_file_tsnr, output_file_mean_tsnr, functional_mask)

%calculate mean
unix_command = sprintf('fslmaths %s -Tmean %s >out.log',input_file,output_file_mean);
system(unix_command);

%calculate std
unix_command = sprintf('fslmaths %s -Tstd %s >out.log',input_file,output_file_std);
system(unix_command);

%calculate tsnr
unix_command = sprintf('fslmaths %s -div %s %s >out.log',output_file_mean,output_file_std,output_file_tsnr);
system(unix_command);

%calculate mean tsnr in mask
unix_command = sprintf('fslstats %s -k %s -m >> %s',output_file_tsnr,functional_mask,output_file_mean_tsnr);
system(unix_command);

%calculate median distance index [quality]:
[status,cmdout] = system(sprintf('3dToutcount %s',input_file));
cmdout = splitlines(cmdout);
cmdout([1 end]) = [];
mean_outlier_detection =  mean(str2double(cmdout));

%calculate mean median distance index
[status,cmdout] = system(sprintf('3dTqual %s',input_file));
cmdout = splitlines(cmdout);
cmdout([1 end]) = [];
mean_median_distance_index =  nanmean(str2double(cmdout));