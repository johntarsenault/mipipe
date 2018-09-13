function [input, params] = remove_outlier_runs(runs2remove, input, params)

orig_length = 1:length(input.file_list);

runs2remove_ID = [];
for i_runs2remove = 1:numel(runs2remove)
    runs2remove_ID(i_runs2remove) = find(cellfun(@(x) numel(findstr(x, sprintf('_IMA_%02d.nii', runs2remove(i_runs2remove)))), input.file_list));
end

if numel(find(params.image_no == runs2remove_ID))
    error('params.image_no is can''t be removed. Please change params.image_no first');
else
    input.file_list(runs2remove_ID) = [];
    orig_length(runs2remove_ID)     = [];
    
    params.image_no = find(orig_length == params.image_no);
end
