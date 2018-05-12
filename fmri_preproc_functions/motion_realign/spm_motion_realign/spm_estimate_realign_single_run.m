function spm_estimate_realign_single_run(input_file,output_file,params)

input_file = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180423_new/funct/_1_source_data/Tank180423_IMA_26.nii';
[input_path, input_file_name, input_ext]  = fileparts(input_file);

for i_tr_no = 1:params.tr_no    
    matlabbatch{1}.spm.spatial.realign.estimate.data{1}{i_tr_no,1} = sprintf('%s,%d',input_file,i_tr_no);
end

                          
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 2;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 3;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';

spm_jobman('initcfg');
spm_jobman('run',matlabbatch);