function assign_order_file_to_json_all(pdf_file_name, json_dir, spm_order_dir,fixation_option)

%get ima numbers and elab log alpha
[ima_no, log_alpha] = get_ima_log_pairs_from_elab_pdf(pdf_file_name);
   
%get full file names from ima_no and log_alpha
[ordered_json_files, ordered_spm_order_files] = find_full_file_names_spm_mat_and_json(json_dir, spm_order_dir, ima_no, log_alpha);

%add spm.mat info to all json files
cellfun(@(json, spm_order) assign_order_file_to_json_single(json, spm_order), ordered_json_files, ordered_spm_order_files);

%get fixation in addition
if fixation_option == 1;
    [fix_no ima_no]     = get_fix_from_elab_pdf(pdf_file_name);
    [fix_string]        = align_fixation_to_ima(fix_no,ima_no,ordered_json_files);  
    cellfun(@(json, fix) assign_fixation_to_json_single(json, fix), ordered_json_files, fix_string);
end