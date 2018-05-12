function input = cleanup_file_list_using_tr_no(base_dir,input, tr_no)

is_file_tr_no_correct = [];

for i_input_files = numel(input.file_list):-1:1
    
    %get tr no using mri_info
    current_file = [base_dir,input.dir, '/', input.file_list{i_input_files}];

    [status, cmdout] = system(sprintf('mri_info %s | grep dimensions | awk ''{print $8}''',current_file));
    file_tr_no = str2double(cmdout);
    
    
    if file_tr_no ~= tr_no
        delete([base_dir,input.dir, '/', input.file_list{i_input_files}]);
	delete([base_dir,input.dir, '/', input.file_list{i_input_files}(1:end-4),'.json']);
        input.file_list(i_input_files) = [];
        is_file_tr_no_correct = 0;
    end
    
end
