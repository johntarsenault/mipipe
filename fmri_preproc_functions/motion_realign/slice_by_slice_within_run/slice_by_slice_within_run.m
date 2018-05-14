function regressor_name = slice_by_slice_within_run(input_file, output_file, params)

addpath /fmri/spm5_utils/prepro_v8_thomas/prepro_tools/prod/mex/

[input_path, input_file, input_ext] = fileparts(input_file);
[print_name_image, print_name_matfile, print_name_txtfile] = mc_undist_wouter_dante3_preproc([input_path, '/'], [input_file, input_ext], output_file, params);

regressor_dir = [params.base_dir, '/funct/regressor/slice_by_slice/'];

if ~exist(regressor_dir)
    mkdir(regressor_dir);
end


movefile(print_name_image, regressor_dir);
movefile(print_name_matfile, regressor_dir);
movefile(print_name_txtfile, regressor_dir);


regressor_name = {'motion_regressor',print_name_txtfile};