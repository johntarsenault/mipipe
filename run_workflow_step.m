function [output, params] = run_workflow_step(input, preproc_function, step_no, params)

%% generate new output directory if it's needed
if preproc_function.is_directory_created
    output.dir = ['funct/_', num2str(step_no), '_', preproc_function.function_name, '/'];
else
    output.dir = input.dir;
end

if ~exist([params.base_dir, output.dir])
    mkdir([params.base_dir, output.dir])
end

%% loop through images if is_each_image_processed == 1
if preproc_function.is_each_image_processed
    
    %% initialize variables
    current_input_file = cell(numel(input.file_list), 1);
    current_output_file = cell(numel(input.file_list), 1);
    file_list = cell(numel(input.file_list), 1);
    regressor_file_name = cell(numel(input.file_list), 1);
    
    %% loop through each input image and run the current preprocessing step
    parfor i_input_file_no = 1:numel(input.file_list)
        
        %assign suffix if suffix is not empty
        if numel(preproc_function.prefix)
            current_file_parts = fileparts_full(input.file_list{i_input_file_no});
            file_list{i_input_file_no} = [current_file_parts.file,'_',preproc_function.prefix, current_file_parts.ext];
        else
            file_list{i_input_file_no} = input.file_list{i_input_file_no};
        end
        
        
        current_input_file{i_input_file_no} = fullfile(params.base_dir, input.dir, input.file_list{i_input_file_no});
        current_output_file{i_input_file_no} = fullfile(params.base_dir, output.dir, file_list{i_input_file_no});
        
        %run preproc step with or without a regressor being generated
        if preproc_function.is_regressor_created
            regressor_file_name{i_input_file_no} = preproc_function.function_call(current_input_file{i_input_file_no}, current_output_file{i_input_file_no}, params);
            add_workflow_step_to_json_w_regressor(current_input_file{i_input_file_no}, current_output_file{i_input_file_no}, preproc_function, step_no, regressor_file_name{i_input_file_no});
        else
            preproc_function.function_call(current_input_file{i_input_file_no}, current_output_file{i_input_file_no}, params);
            add_workflow_step_to_json(current_input_file{i_input_file_no}, current_output_file{i_input_file_no}, preproc_function, step_no);
        end
        
    end
    
    %assign output file_list to new file
    output.file_list = file_list;
    
else
    output.file_list = input.file_list;
    params = preproc_function.function_call(input, params);
end
