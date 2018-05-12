function workflow = remove_non_looping_workflow_step(workflow)

%% remove non-looping workflow steps
for i_step = 1:numel(workflow.step)
   is_each_image_processed(i_step) =  workflow.step(i_step).preproc_function.is_each_image_processed;
end
non_loop_ID = find(~is_each_image_processed);

workflow.step(non_loop_ID) = [];

