function params = make_mean_target(input, params)


target_file_4D = [params.base_dir, input.dir, input.file_list{params.image_no}];

if ~exist(target_file_4D)
    error('file to be used for mean target image doesn''t exist: %s', target_file_4D);
end



target_image_4D = MRIread(target_file_4D);
target_image_4D.vol = mean(target_image_4D.vol,4);




[target_file_4D_path, target_file_4D_name, target_file_4D_ext] = fileparts(target_file_4D);


output_dir = [params.base_dir, 'funct/mask/'];
if ~exist(output_dir)
    mkdir(output_dir)
end

output_file = [output_dir, target_file_4D_name, '_mean_target.nii'];

MRIwrite(target_image_4D,output_file);

params.mean_target = output_file;