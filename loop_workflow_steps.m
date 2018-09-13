function workflow = loop_workflow_steps(step_no_function_pair, input, params, start_step, workflow)

% if start_step not defined
if ~exist('start_step', 'var')
    start_step = 1;
end


for i_step_no = start_step:size(step_no_function_pair, 1)
    
    %get current function and step number
    current_function = step_no_function_pair{i_step_no, 2};
    current_step_no = step_no_function_pair{i_step_no, 1};
    disp(sprintf('initiating step - %d: %s\n', current_step_no, current_function))
    
    % get current steps inputs then save
    % used to re-generate work flow after a crash
    workflow.step_no_function_pair = step_no_function_pair
    workflow.step(i_step_no).input = input;
    workflow.step(i_step_no).params = params;
    workflow.step(i_step_no).preproc_function = get_preproc_functions(current_function);
    save(fullfile(params.base_dir, 'workflow.mat'), 'workflow')
    
    % run current step
    [output, params] = run_workflow_step(input, get_preproc_functions(current_function), current_step_no, params);
    
    % get current step outputs
    workflow.step(i_step_no).output = output;
    
    % assign output of current step to input of next step
    input = output;
    disp(sprintf('completed step - %d: %s \n\n', current_step_no, current_function))
end
