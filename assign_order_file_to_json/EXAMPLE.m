pdf_file_name = '/data/luna/luna_j/GBW-0280_Neuro_Backup/_transfer_/John/20180425-Datasheets Scanner_ Tank180425.pdf';
json_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180423/kanade/funct/_7_fsl_smooth_preproc/';
spm_order_dir = '/data/fmri_monkey_03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_spm_matFiles/Tank20180423/';

%get ima numbers and elab log alpha
[ima_no, log_alpha] = get_ima_log_pairs_from_elab_pdf(pdf_file_name);

%get full file names from ima_no and log_alpha
[ordered_json_files, ordered_spm_order_files] = find_full_file_names_spm_mat_and_json(json_dir, spm_order_dir, ima_no, log_alpha);

%add spm.mat info to all json files
cellfun(@(json, spm_order) assign_order_file_to_json_single(json, spm_order), ordered_json_files, ordered_spm_order_files);