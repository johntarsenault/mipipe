function add_workflow_step_to_json(current_input_file, current_output_file, preproc_function, step_no)

%get input json name
[input_path, input_file, input_ext] = fileparts(current_input_file);
input_json = fullfile(input_path, [input_file, '.json']);

if exist(input_json)
    
    %build output json name
    [output_path, output_file, output_ext] = fileparts(current_output_file);
    output_json = fullfile(output_path, [output_file, '.json']);
    
    %read in input json
    input_json_text = fileread(input_json);
    
    %convert text to structure
    input_json_struct = jsondecode(input_json_text);
    
    %add values to json structure
    input_json_struct.(['preproc_step_', num2str(step_no), '_name']) = preproc_function.function_name;
    input_json_struct.(['preproc_step_', num2str(step_no), '_description']) = preproc_function.function_description;
    input_json_struct.(['preproc_step_', num2str(step_no), '_prefix']) = preproc_function.prefix;
    
    %convert struct to text
    output_json_text = jsonencode(input_json_struct);
    output_json_text = strrep(output_json_text,',',',\n');
    output_json_text = strrep(output_json_text,'%','%%');

    %write text to json file
    fid = fopen(output_json, 'w');
    if fid == -1
        error('Cannot create JSON file');
    end
    fprintf(fid, output_json_text);
    fclose(fid);
    
else
    warning([input_json, ' does not exist!']);
end