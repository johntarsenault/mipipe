function workflow = loop_workflow_steps(step_no_function_pair,input,params)

for i_step_no = 1:size(step_no_function_pair, 1)
    
    %get current function and step number
    current_function = step_no_function_pair{i_step_no, 2};
    current_step_no = step_no_function_pair{i_step_no, 1};
    
    %get current steps inputs; useful if crashes
    workflow.step(i_step_no).input = input;
    
    %run current step
    [output, params] = run_workflow_step(input, get_preproc_functions(current_function), current_step_no, params);
    
    %get current step outputs; useful to track function
    workflow.step(i_step_no).output = output;
    workflow.step(i_step_no).params = params;
    workflow.step(i_step_no).preproc_function = get_preproc_functions(current_function);
    
    %assign output of current step to input of next step
    input = output;
end
