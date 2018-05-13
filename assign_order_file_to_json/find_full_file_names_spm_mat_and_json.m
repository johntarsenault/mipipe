function [ordered_json_files, ordered_spm_order_files] = find_full_file_names_spm_mat_and_json(json_dir, spm_order_dir, ima_no, log_alpha)

%list all files in directories
json_files = util.dirr(json_dir, '.json', 0, 'file');
spm_order_files = util.dirr(spm_order_dir, '_spm.mat', 0, 'file');

%assign each im_no log_alpha pair to a full filename
counter = 0;
for i_ima_no = 1:numel(ima_no)
    
    current_json_file_ID = find(cellfun(@(x) numel(findstr(x, sprintf('IMA_%02d', ima_no(i_ima_no)))), json_files));
    current_spm_order_file_ID = find(cellfun(@(x) numel(findstr(x, sprintf('_%s_spm.mat', log_alpha{i_ima_no}))), spm_order_files));
    
    if isempty(current_json_file_ID) || isempty(current_spm_order_file_ID)
        if isempty(current_json_file_ID)
            warning(sprintf('no json with *IMA_%02d* in directory: %s', ima_no(i_ima_no), json_dir))
        end
        
        if isempty(current_spm_order_file_ID)
            warning(sprintf('no spm order file with *_%s_spm.mat in directory: %s', log_alpha{i_ima_no}, spm_order_dir))
        end
    else
        
        counter = counter+1;
        ordered_json_files{counter} = json_files{current_json_file_ID};
        ordered_spm_order_files{counter} = spm_order_files{current_spm_order_file_ID};
        disp(sprintf('nifti image: *IMA_%02d* was matched with spm order file: *_%s_spm.mat', ima_no(i_ima_no), log_alpha{i_ima_no}))
    end
end