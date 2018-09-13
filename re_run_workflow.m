function re_run_workflow(base_dir, start_step, params_new)

% if params_new not defined
if ~exist('params_new','var')
  params_new = struct([]);
end

% load workflow ino data
load(fullfile(base_dir,'workflow.mat'));

step_no_function_pair = workflow.step_no_function_pair;
input = workflow.step(start_step).input;
params = workflow.step(start_step).params;

f = fieldnames(params_new);
for i = 1:length(f)
    params.(f{i}) = params_new.(f{i})
end
 
workflow = loop_workflow_steps(step_no_function_pair, input, params, start_step, workflow);
